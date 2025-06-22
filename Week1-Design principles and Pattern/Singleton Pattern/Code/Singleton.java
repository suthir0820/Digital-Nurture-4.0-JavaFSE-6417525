public class Singleton {
    private static volatile Singleton instance;
    private Singleton() { }

    public static Singleton getInstance() {
        if (instance == null) {
            synchronized (Singleton.class) {
                if (instance == null) {
                    instance = new Singleton();
                }
            }
        }
        return instance;
    }
    public void doSomething() {
        System.out.println("Singleton instance is working.");
    }
    public static void main(String[] args) {
        Singleton singleton1 = Singleton.getInstance();
        Singleton singleton2 = Singleton.getInstance();

        singleton1.doSomething();

        // Prove both references point to the same instance
        if (singleton1 == singleton2) {
            System.out.println("Both references are the same instance.");
        } else {
            System.out.println("Different instances exist!");
        }
    }
}