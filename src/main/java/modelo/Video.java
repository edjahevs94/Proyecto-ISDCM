package modelo;

public class Video {

    private int id;
    private String titulo;
    private String autor;
    private String fechaCreacion;
    private String duracion;
    private int reproducciones;
    private String descripcion;
    private String formato;
    private String rutaFichero;

    private int usuarioId;


    
    public Video() {}

    public Video(String titulo, String autor, String fechaCreacion,
                 String duracion, int reproducciones,
                 String descripcion, String formato, String rutaFichero) {
        this.titulo        = titulo;
        this.autor         = autor;
        this.fechaCreacion = fechaCreacion;
        this.duracion      = duracion;
        this.reproducciones = reproducciones;
        this.descripcion   = descripcion;
        this.formato       = formato;
        this.rutaFichero = rutaFichero;
    }

    public int getUsuarioId() { 
        return usuarioId; 
    }
    public void setUsuarioId(int usuarioId) { 
        this.usuarioId = usuarioId;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public String getAutor() {
        return autor;
    }

    public void setAutor(String autor) {
        this.autor = autor;
    }

    public String getFechaCreacion() {
        return fechaCreacion;
    }

    public void setFechaCreacion(String fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }

    public String getDuracion() {
        return duracion;
    }

    public void setDuracion(String duracion) {
        this.duracion = duracion;
    }

    public int getReproducciones() {
        return reproducciones;
    }

    public void setReproducciones(int reproducciones) {
        this.reproducciones = reproducciones;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public String getFormato() {
        return formato;
    }

    public void setFormato(String formato) {
        this.formato = formato;
    }

    public String getRutaFichero() {
        return rutaFichero;
    }

    public void setRutaFichero(String rutaFichero) {
        this.rutaFichero = rutaFichero;
    }
    
}
