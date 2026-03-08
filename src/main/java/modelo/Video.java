/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelo;

/**
 *
 * @author alumne
 */
public class Video {

    private int id;
    private String titulo;
    private String autor;
    private String fechaCreacion;  // DATE  → String "yyyy-MM-dd"
    private String duracion;       // TIME  → String "HH:mm:ss"
    private int reproducciones;
    private String descripcion;
    private String formato;

    public Video() {}

    public Video(String titulo, String autor, String fechaCreacion,
                 String duracion, int reproducciones,
                 String descripcion, String formato) {
        this.titulo        = titulo;
        this.autor         = autor;
        this.fechaCreacion = fechaCreacion;
        this.duracion      = duracion;
        this.reproducciones = reproducciones;
        this.descripcion   = descripcion;
        this.formato       = formato;
    }

    // Getters y Setters
    public int getId(){ 
        return id; 
    }
    public void setId(int id)                 { this.id = id; }

    public String getTitulo()                 { return titulo; }
    public void setTitulo(String titulo)      { this.titulo = titulo; }

    public String getAutor()                  { return autor; }
    public void setAutor(String autor)        { this.autor = autor; }

    public String getFechaCreacion()          { return fechaCreacion; }
    public void setFechaCreacion(String f)    { this.fechaCreacion = f; }

    public String getDuracion()               { return duracion; }
    public void setDuracion(String duracion)  { this.duracion = duracion; }

    public int getReproducciones()            { return reproducciones; }
    public void setReproducciones(int r)      { this.reproducciones = r; }

    public String getDescripcion()            { return descripcion; }
    public void setDescripcion(String d)      { this.descripcion = d; }

    public String getFormato()                { return formato; }
    public void setFormato(String formato)    { this.formato = formato; }
}
