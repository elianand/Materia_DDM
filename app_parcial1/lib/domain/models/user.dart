class User {
    int idUser;
    int idComp;
    String name;
    String email;
    String password;   // Atributo privado
    int? age;   // Puede ser null

    /*
    Metodo tradicional
    User(id, name, email, password, age) :
        this.id = id,
        this.name = name,
        this.email = email,
        this.password = password,
        this.age = age;
    */

    // Metodo preferido por Dart, no hace falta ponerlos en orden
    // Si no es requerido un campo le podemos sacar el requiered
    User({
        required this.idUser,
        required this.idComp,
        required this.name,
        required this.email,
        required this.password,
        this.age = 0,
    });

    void printUser() {
        print("User: $name, Email: $email");
    }

    bool checkEmail(String email) {
        if(email == this.email){
            return true;
        }
        return false;
    }

    bool checkPass(String password) {
        if(password == this.password){
            return true;
        }
        return false;
    }

    String greet() {
        return "Hello $name";
    }



}
