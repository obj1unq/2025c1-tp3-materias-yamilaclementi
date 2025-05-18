class Estudiante {
    const materiasAprobadas = #{} // Aca es const poque la coleccion no cambia como tal, solo lo de adentro
    const carreras = #{}
    const materiasInscriptas = #{}
    const materiasEnEspera = #{}

// Punto 1
    method aprobada(materia, nota) {
        self.validarMateriaAprobada(materia) // Punto 3
        materiasAprobadas.add(new Curso (materia = materia, nota = nota)) //Con la clase Curso, creo la materia con su nota
    }

    method validarMateriaAprobada(materia) {
        if (self.tieneAprobada(materia)) 
            self.error ("Esta materia ya esta registrada")
    }

/*     method enCarrera(carrera) {
        carreras.add(carrera)
    }

 */

// Punto 2
    method cantidadDeMateriasAprobadas() {
        return materiasAprobadas.size()
    }

    method promedio() {
        if (materiasAprobadas.isEmpty()) // Hace falta chequear que no este vacia? 
            return 0
        var sumaDeNotas = materiasAprobadas.sum({ curso => curso.nota()})
            return sumaDeNotas / self.cantidadDeMateriasAprobadas()
    }

    method tieneAprobada(materia){
       return materiasAprobadas.any({curso => curso.materia() == materia}) //materiasAprobadas.contains(materia)
    }

// Punto 4
    method todasLasMaterias() {
        return carreras.map({carrera => carrera.materias()}).flatten() // carreras.flatMap({carrera => carrera.materias()}) esto es igual?
    }

// Punto 5
    method puedeInscribirseA(materia) {
        return self.perteneceAAlgunaCarreraEnCurso(materia) && 
                not self.tieneAprobada(materia) &&
                not self.estaInscriptoA(materia) &&
                materia.requisitosAprobados(self)
                
    }

    method perteneceAAlgunaCarreraEnCurso(materia) {
        return self.todasLasMaterias().contains(materia)
    }

    method estaInscriptoA(materia) {
        return materiasInscriptas.contains(materia)
    }
// Punto 6
    method inscribirse(materia) {
        self.validarCondicionesDeInscripción(materia)
        materia.inscribir(self)
        materiasInscriptas.add(materia)
    }

    method validarCondicionesDeInscripción(materia) {
        if (not self.puedeInscribirseA(materia)) {
            self.error("No cumple con las condiciones de inscripción")
        }
    }

    method revocacionDeMateria(materia) {
        materiasInscriptas.remove(materia)
    }

// Punto 9
    method materiasEnLasQueInscribio(){                                                                     
        return self.todasLasMaterias().filter({materia => materiasInscriptas.contains(materia)})

    }

    method materiasEnListaDeEspera(){                                                                       
        return self.todasLasMaterias().filter({materia => materiasEnEspera.contains(materia)})
    }
    
// Punto 10
    method materiasQuePuedeHacerDe(carrera) {
        self.validarCursadaDeCarrera(carrera)
        carrera.materias()
    }

    method validarCursadaDeCarrera(carrera) {
        if (not self.cursaLaCarrera(carrera)) {
                self.error("No pertenece a la carrera en cuestion")
        }
    }

    method cursaLaCarrera(carrera) {
        return carreras.contains(carrera)
    }
}

class Curso {

    const property materia    // const o var?
    const property nota       // const o var?

}

class Carrera {

    const property materias = #{}
}

class Materia {

    const requisitos = #{}  // Los requisitos son materias correlativas aprobadas
    var cupos = 35
    const listaDeEspera = []       // Listas porque necesitamos un orden 
    const listaDeConfirmados = []

    method requisitosAprobados(estudiante) {  
        return requisitos.all({requisito => estudiante.tieneAprobada(requisito)}) 
    }

// Nota de Ayuda:
//         [mate, fisica].all({requisito => estudiante.tieneAprobada(requisito)}) 
//         [mate, fisica].all({mate => estudiante.tieneAprobada(mate)}) --> True
//         [mate, fisica].all({fisica => estudiante.tieneAprobada(fisica)}) --> True

// cuando hablamos de requisitos, nos referimos a Materias aprobadas 
// En la coleccion requisitos estan todas las materias correlativas a una materia.
// La condición es si el estudiate tiene aprobadas, todas las materias de la colección

// tieneAprobada, es un metodo de la clase Estudiante. 
// Tiene un .any, que recorre la colección buscando alguno que coincida 
    
// Punto 6
    method inscribir(estudiante) {
        self.validarEsperaOConfirmacion(estudiante) // Filtro para entrar a cupos
        if (cupos > 0) {
            listaDeConfirmados.add(estudiante)
            cupos = cupos - 1
        } 
    }

    method validarEsperaOConfirmacion(estudiante) {
        if (self.esAlumnoEnEspera(estudiante) || self.esAlumnoConfirmado(estudiante)) {
            self.error("Este alumno ya se escuentra en proceso de inscripcion")
        }
        // Para manejar el exceso en los cupos, las materias tienen una lista de espera, 
        // de estudiantes que quisieran cursar pero no tienen lugar 
    } 

    method esAlumnoEnEspera(estudiante) {
        return listaDeEspera.contains(estudiante)
    }

    method esAlumnoConfirmado(estudiante) {
        return listaDeConfirmados.contains(estudiante)
    }
// Punto 7
    method darDeBaja(estudiante) {
        listaDeConfirmados.remove(estudiante)
        if (not listaDeEspera.isEmpty()) {
            listaDeConfirmados.add(listaDeEspera.first())
            listaDeEspera.remove().first()
        }
    }

// Punto 8
    method listaDeEspera() {
        return listaDeEspera
    }

    method listaDeConfirmados() {
        return listaDeConfirmados
    }
    
}