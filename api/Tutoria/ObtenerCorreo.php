<?php
// DMCH
include("../../../../../bases_datos/adodb/adodb.inc.php");
include("../../../../../bases_datos/usb_defglobales.inc");

header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

$dbi = NewADOConnection("$motor_p");
$dbi->Connect($base_p, $usuario_p, $contra_p);

if (!$dbi) {
        echo json_encode(array("status" => "error", "message" => "Error al conectar con la base de datos: " . $dbi->ErrorMsg()));
        exit;
}

// Verificar si se recibió el código del estudiante
if (isset($_POST["Codigo"])) {
    // Obtener y sanitizar el código del estudiante
    $doc_est = $dbi->qstr($_POST['Codigo']);

    // Consultar el correo institucional del estudiante
    $consultaCorreo = "SELECT CORREOINSTITUCIONAL FROM ACADEMICO.ESTUDIANTES_TUTORIAS_TB WHERE DOCUMENTO = $doc_est";

    $ejecutarConsulta = $dbi->Execute($consultaCorreo);

    // Verificar si se obtuvo algún resultado
    if ($ejecutarConsulta && $ejecutarConsulta->RecordCount() > 0) {
        // Obtener el resultado
        $correoInstitucional = $ejecutarConsulta->fields['CORREOINSTITUCIONAL'];

        // Crear un array con el resultado y convertirlo a JSON
        $result = array('CORREOINSTITUCIONAL' => $correoInstitucional);
        echo json_encode($result);
    } else {
        // No se encontró el correo para el estudiante
        echo json_encode(array('error' => 'No se encontró un correo para el estudiante'));
    }
} else {
    // No se proporcionó el código del estudiante
    echo json_encode(array('error' => 'No se proporcionó el código del estudiante'));
}

// Cerrar conexión a la base de datos
$dbi->Close();
?>