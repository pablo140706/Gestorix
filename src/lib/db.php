<?php
// =====================================================================
//  La única conexión a la base. Todo lo demás hace:
//      require __DIR__ . '/../lib/db.php';   $pdo = db();
//  Los datos salen de variables de entorno (docker-compose.yml → .env),
//  nunca escritos aquí.
// =====================================================================

function db(): PDO
{
    static $pdo = null;
    if ($pdo === null) {
        $dsn = sprintf('pgsql:host=%s;dbname=%s', getenv('DB_HOST'), getenv('DB_NAME'));
        $pdo = new PDO($dsn, getenv('DB_USER'), getenv('DB_PASSWORD'), [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,  // un error SQL truena, no se esconde
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        ]);
    }
    return $pdo;
}
