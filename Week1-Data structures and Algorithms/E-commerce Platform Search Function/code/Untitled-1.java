import java.util.*;
class Product {
    private int id;
    private String name;
    private String category;
    private double price;

    public Product(int id, String name, String category, double price) {
        this.id = id;
        this.name = name.toLowerCase();
        this.category = category.toLowerCase();
        this.price = price;
    }

    public String getName() {
        return name;
    }

    public String getCategory() {
        return category;
    }

    public double getPrice() {
        return price;
    }

    public String toString() {
        return String.format("Product{id=%d, name='%s', category='%s', price=%.2f}", id, name, category, price);
    }
}

class ECommerceSearch {
    private List<Product> products;

    public ECommerceSearch() {
        products = new ArrayList<>();
    }

    public void addProduct(Product product) {
        products.add(product);
    }
    public List<Product> searchByName(String query) {
        List<Product> result = new ArrayList<>();
        String lowerQuery = query.toLowerCase();
        for (Product product : products) {
            if (product.getName().contains(lowerQuery)) {
                result.add(product);
            }
        }
        return result;
    }
    public List<Product> searchByCategory(String category) {
        List<Product> result = new ArrayList<>();
        String lowerCategory = category.toLowerCase();
        for (Product product : products) {
            if (product.getCategory().equals(lowerCategory)) {
                result.add(product);
            }
        }
        return result;
    }

    public static void main(String[] args) {
        ECommerceSearch platform = new ECommerceSearch();
        platform.addProduct(new Product(1, "Apple iPhone 15", "Electronics", 999.99));
        platform.addProduct(new Product(2, "Samsung Galaxy S24", "Electronics", 899.99));
        platform.addProduct(new Product(3, "Nike Running Shoes", "Footwear", 120.00));
        platform.addProduct(new Product(4, "Apple MacBook Pro", "Electronics", 1999.99));

        Scanner scanner = new Scanner(System.in);
        System.out.print("Enter product name to search: ");
        String query = scanner.nextLine();

        List<Product> results = platform.searchByName(query);
        if (results.isEmpty()) {
            System.out.println("No products found.");
        } else {
            System.out.println("Search results:");
            for (Product p : results) {
                System.out.println(p);
            }
        }
    }
}