use Academy;

CREATE DATABASE IF NOT EXISTS academy DEFAULT CHARACTER SET utf8mb4;
USE academy;

-- 1. Tipo de Usuario
CREATE TABLE tipo_usuario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion TEXT,
    create_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    estado ENUM('activo', 'inactivo') DEFAULT 'activo'
);

-- 2. Usuario
CREATE TABLE usuario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL, 
    contrasena NVARCHAR(255) NOT NULL, -- NVARCHAR porque la contraseña se puede hashear
    tipo_usuario_id INT,
    create_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    estado ENUM('activo', 'inactivo') DEFAULT 'activo',
    FOREIGN KEY (tipo_usuario_id) REFERENCES tipo_usuario(id)
);

-- 3. Academia
CREATE TABLE academia (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion TEXT,
    telefono VARCHAR(20),
    create_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    estado ENUM('activo', 'inactivo') DEFAULT 'activo'
);

-- 4. Tipo de Curso
CREATE TABLE tipo_curso (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion TEXT,
    create_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    estado ENUM('activo', 'inactivo') DEFAULT 'activo'
);

-- 5. Curso
CREATE TABLE curso (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    tipo_curso_id INT,
    academia_id INT,
    fecha_inicio DATE, -- fecha que inicia el curso   
    fecha_fin DATE,    -- fecha que finaliza el curso        
    create_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    estado ENUM('activo', 'inactivo') DEFAULT 'activo',
    FOREIGN KEY (tipo_curso_id) REFERENCES tipo_curso(id),
    FOREIGN KEY (academia_id) REFERENCES academia(id)
);


-- 6. Alumno
CREATE TABLE alumno (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT,
    academia_id INT,
    create_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    estado ENUM('activo', 'inactivo') DEFAULT 'activo',
    FOREIGN KEY (usuario_id) REFERENCES usuario(id),
    FOREIGN KEY (academia_id) REFERENCES academia(id)
);

-- 7. Profesor
CREATE TABLE profesor (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT,
    academia_id INT,
    especialidad VARCHAR(100), -- si se desempeña en el area de tecnologia, cocina, cientifica, etc
    create_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    estado ENUM('activo', 'inactivo') DEFAULT 'activo',
    FOREIGN KEY (usuario_id) REFERENCES usuario(id),
    FOREIGN KEY (academia_id) REFERENCES academia(id)
);

-- 8. Administración
CREATE TABLE administracion (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT,
    academia_id INT,
    cargo VARCHAR(100), -- descripcion del cargo administrativo
    create_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    estado ENUM('activo', 'inactivo') DEFAULT 'activo',
    FOREIGN KEY (usuario_id) REFERENCES usuario(id),
    FOREIGN KEY (academia_id) REFERENCES academia(id)
);

-- 9. Asignación de Cursos (Alumno y Profesor)
CREATE TABLE asignacion_curso (
    id INT AUTO_INCREMENT PRIMARY KEY,
    curso_id INT,
    alumno_id INT,
    profesor_id INT,
    fecha_inicio DATE,
    fecha_fin DATE,
    create_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    estado ENUM('activo', 'inactivo') DEFAULT 'activo',
    FOREIGN KEY (curso_id) REFERENCES curso(id),
    FOREIGN KEY (alumno_id) REFERENCES alumno(id),
    FOREIGN KEY (profesor_id) REFERENCES profesor(id)
);

-- 10. Notas
-- criterio de evaluacion: aca podra el profesor dividir la ponderacion del curso a corde su cirterio bajo el 100% de la nota
-- es decir puede dividirlo en parciales, EF, tareas
CREATE TABLE criterio_evaluacion (
     id INT AUTO_INCREMENT PRIMARY KEY,
    profesor_id INT,
    curso_id INT,
    nombre VARCHAR(100), -- Tareas,EF, etc
    porcentaje DECIMAL(5,2), 
    create_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (profesor_id) REFERENCES profesor(id),
    FOREIGN KEY (curso_id) REFERENCES curso(id)
);
-- aqui es donde el profesor podrá ingresar la nota de la tarea 
CREATE TABLE nota_alumno (
    id INT AUTO_INCREMENT PRIMARY KEY,
    alumno_id INT,
    curso_id INT,
    criterio_id INT,
    nota DECIMAL(5,2), -- la nota del alumno a corde a la asignacion de la tarea
    comentario TEXT,
    create_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (alumno_id) REFERENCES alumno(id),
    FOREIGN KEY (curso_id) REFERENCES curso(id),
    FOREIGN KEY (criterio_id) REFERENCES criterio_evaluacion(id)
);

-- aca es donde se guardará la calificacion final del alumno 
CREATE TABLE nota_final (
    id INT AUTO_INCREMENT PRIMARY KEY,
    alumno_id INT,
    curso_id INT,
    nota_total DECIMAL(5,2),
    observaciones TEXT,
    prefesor_id INT,
    create_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (alumno_id) REFERENCES alumno(id),
    FOREIGN KEY (curso_id) REFERENCES curso(id)
);
