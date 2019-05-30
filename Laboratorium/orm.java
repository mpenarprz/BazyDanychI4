import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/******
W ten sposób piszemy adnotacje w Javie. W C# jest podobnie: https://docs.microsoft.com/pl-pl/dotnet/csharp/programming-guide/concepts/attributes/
 Adnotacje powinny mieć informacje na temat tego kiedy są dostępne: służy do tego adnotacja @Retention
 Dodatkowo można podpowiedzieć gdzie adnotacja może być stosowana za pomocą adnotacji: @Target

 Pola w adnotacjach mogą korzystać z typów prostych wewnątrz.
 ******/

/*
Ta adnotacja służy do przechowywania informacji odnośnie nazwy tabeli
 */
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@interface MyTableAnnotation{
    String name();
}

/*
Ta adnotacja służy do przechowywania informacji odnośnie nazwy pola ... i innych własności
 */
@Target(ElementType.FIELD)
@Retention(RetentionPolicy.RUNTIME)
@interface MyFieldAnnotation{
    String name();
    String type();
    int length() default 0;
}


/******
Tu są nasze klasy testowe pokazujące jak korzystać z adnotacji
 ******/
@MyTableAnnotation(name = "TEST_TABLE")
class TestModel{

    @MyFieldAnnotation(name = "id", type = "ABBA")
    private int someIdField;

    private String someText;

    public TestModel() {}

}

@MyTableAnnotation(name = "MoReTest")
class TestModel2{

    @MyFieldAnnotation(name = "id", type = "ABBA")
    private int someIdField;

    @MyFieldAnnotation(name = "tttt", type = "VARCHAR(100)")
    private String someText;

    public TestModel2(int someIdField, String someText) {
        this.someIdField = someIdField;
        this.someText = someText;
    }
}

class TestModel3{}

/******
 A tu jest nasz ORM który nie wykonuje wprawdzie zapytań, ale generuje je na podstawie klas.
 W rzeczywistości ORM powinen wygenerować SQL i go wykonać na docelowej Bazie Danych
 ******/
class ORM{

    static String createTable(Object o) throws Exception {
        // W pierwszej kolejności pobieramy informacje na temat klasy przekazanego obiektu `o`
        var clazz = o.getClass();

        /*
        W drugiej kolejności pobieramy informacje odnośnie utworzonej adnotacji - jeśli jest.
        Jak nie, to .. sprawdzam i wyrzucam wyjątek.
        Być może ktoś stwierdzi że nie będzie wyrzucał wyjątku i skorzysta z nazwy klasy jako nazwy tabeli
         */
        var tableAnnotation = clazz.getAnnotation(MyTableAnnotation.class);
        if(tableAnnotation == null) throw new IllegalArgumentException("Klasa nie ma adnotacji @MyTableAnnotation");

        /*
            Najtrudniejszy fragment. Iterujemy po polach i wybieramy adnotacje @MyFieldAnnotation.
            Dla każdego pola posiadającego tę adnotację dołączamy kolejne linie SQL'a
         */
        var insideCreateTable = new StringBuilder("");
        for(var field : clazz.getDeclaredFields()){
            var fieldAnnotation = field.getAnnotation(MyFieldAnnotation.class);
            if(fieldAnnotation != null){
                /*
                Przecinki dla kolejnych linii
                 */
                if(insideCreateTable.length() > 1){
                    insideCreateTable.append(",\n");
                }
                /*
                Dołączenie {nazwa pola} {typ danych}
                 */
                insideCreateTable.append("\t")
                        .append(fieldAnnotation.name())
                        .append(" ")
                        .append(fieldAnnotation.type());
            }

            /*
            Jakby istniała potrzeba dobicia się do wartości w obiekcie to można tak:

            Krok 1: dla pól prywatnych trzeba ustawić refleksyjnie dostęp do tych pól

            field.setAccessible(true);

            Krok 2: pobrać wartość pola. Tu mamy odwrócony model. Tj. posiadamy referencję na pole, ale nie wiadomo jakiego obiektu.
            Obiekt jest podany w parametrze: field.get(o)

            System.out.println(field.get(o));
             */
        }

        // Na wyjściu zwracamy gotowego SQL'a
        return String.format("CREATE TABLE %s (\n%s\n);", tableAnnotation.name(), insideCreateTable.toString());
    }
}

/****
    Analogicznie postępujemy dla INSERT/DELETE/UPDATE
    Z SELECT'ami jest o wiele trudniej.

 Zauważmy że INSERT INTO zależy od stanu obiektu który przekazujemy tj. hipotetyczne wywołanie:
 var model = new TestModel2(1, "asdsds");
 ORM.insertInto(model);

 Powinno wywołać SQL:
 INSERT INTO MoReTest VALUES('1', 'asdsds');

 W takim wypadku potrzebujemy odwołać się do stanu obiektu (wcześniejszy komentarz: Field.get(o);)

 Tip: Adnotacja @MyFieldAnnotation ma bezsensowny atrybut 'type' - tę informację można pobrać z klasy Field:
 field.getType()

 ****/


public class Main {

    /****
    Pokaz działania. Nasza klasa generuje SQL'e! Gotowe do wywołania.
     ****/
    public static void main(String[] args) throws Exception {
        System.out.println(ORM.createTable(new TestModel()));
        System.out.println(ORM.createTable(new TestModel2(1, "asdsds")));
        try{
            ORM.createTable(new TestModel3());
        }catch (IllegalArgumentException ex){
            System.out.println("Poprawny wyjątek:" + ex.getMessage());
        }

    }

    /****
     Tak naprawdę dla SELECT najtrudniejsze jest 'oddanie' zapytań i związków.
     Stosunkowo łatwym zadaniem jest wywołanie dowolnego SQL'a (w założeniu poprawnego) i automatyczne
     przemapowanie go na typ docelowy.

     Jak ktoś się chce z tym zmierzyć to sygnatura funkcji będzie mniej więcej:

     public <T> T[] executeSQL(String sql, Class<T> target){}

     Pod spodem przykład jak to działa
     ****/

    private static <T> T back(T obj){
        return obj;
    }

    private static <T> T backClass(Class<T> tClass){
        return null;
    }

    private static void test(){
        /*
        Tu pokaz. Jaki obiekt wkładam, taki wychodzi, na podstawie obiektu
         */
        int i = back(1);
        String j = back("a");

        /*
        Tu pokaz. Jaki obiekt wkładam, taki wychodzi, na podstawie literału class
         */
        Integer k = backClass(Integer.class);
        TestModel l = backClass(TestModel.class);
        TestModel2[] m = backClass(TestModel2[].class);
    }
}