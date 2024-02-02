<?php
// DMCH
include("../../bases_datos/adodb/adodb.inc.php");
include("../../bases_datos/usb_defglobales.inc");

header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');
header("Content-Type: application/json");

$dbi = NewADOConnection("$motor_p");
$dbi->Connect($base_p, $usuario_p, $contra_p);

if (!$dbi) {
        echo json_encode(array("status" => "error", "message" => "Error al conectar con la base de datos: " . $dbi->ErrorMsg()));
        exit;
}

$json = array();

if (isset($_POST["identificacion"])) {
    $identificacion = $dbi->qstr($_POST["identificacion"]); // Escapar y citar el valor

    // Consulta SQL
    $profesor_estudiante = "SELECT DISTINCT DOCUMENTO, EMPLID, NOMBRE, 'NO' NIT FROM academico.REPORTE_MATRICULADO_TB WHERE (DOCUMENTO = $identificacion OR EMPLID = $identificacion) AND (DOCUMENTO IS NOT NULL AND EMPLID IS NOT NULL) AND STRM IN
    (SELECT CODIGO_ASIS FROM ASIS_PERIODO_ACADEMICO WHERE TiPE_CODIGO IN (SELECT CASE WHEN EXTRACT(MONTH FROM sysdate) >= 1 AND EXTRACT(MONTH FROM sysdate) <= 6 THEN 1 ELSE 3 END r FROM dual) AND ano IN (SELECT EXTRACT(YEAR FROM sysdate) FROM DUAL))
    UNION
    SELECT DISTINCT NIT, 'NO' NIT, NOMBRE || ' ' || APELLIDO NOAP, EMPRESA FROM ACADEMICO.EMPLEADOS WHERE (NIT = $identificacion) AND (NIT IS NOT NULL) AND (EMPRESA = 'DOC')
";

    $ejecutar_consulta = $dbi->Execute($profesor_estudiante);

    if ($ejecutar_consulta && $ejecutar_consulta->RecordCount() > 0) {
        $valor_DOCUMENTO = $ejecutar_consulta->fields['DOCUMENTO'];
        $valor_EMPLID = $ejecutar_consulta->fields['EMPLID'];
        $valor_NOMBRE = $ejecutar_consulta->fields['NOMBRE'];
        $valor_NIT = $ejecutar_consulta->fields['NIT'];

        $resulta["DOCUMENTO"] = $valor_DOCUMENTO;
        $resulta["EMPLID"] = $valor_EMPLID;
        $resulta["NOMBRE"] = $valor_NOMBRE;
        $resulta["NIT"] = $valor_NIT;

        echo json_encode($resulta);
    } else {
        echo json_encode(["error" => "No se encontraron registros para el ID $identificacion"]);
    }
} else {
    echo json_encode(["error" => "No se proporcionó identificación"]);
}

$dbi->close();