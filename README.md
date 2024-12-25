
# LaTeX and PSTricks Docker Image

---

## How to Compile

Follow these steps to compile the LaTeX source files for this whitepaper using Docker:

### 1. **Place Your Files**
   - Place your `.tex` files in the `tex` folder. If you prefer to use a different directory, update the `-v` option in the `docker run` command accordingly.

### 2. **Use `make` Commands**
   - To manage the LaTeX compilation process more efficiently, use the provided `Makefile`. Below are the available commands:

   - **Build the PDF**: Compile the LaTeX file into a PDF:
     ```bash
     make build
     ```

   - **Clean Auxiliary Files**: Remove unnecessary LaTeX auxiliary files (`.aux`, `.log`, `.toc`, etc.):
     ```bash
     make clean-latex
     ```

   - **Reset Repository**: Discard changes and remove untracked files:
     ```bash
     make clean
     ```

   - **Run an Interactive Shell in Docker**: Open a shell for manual commands or debugging:
     ```bash
     make ssh
     ```

## PSTricks Section

If your LaTeX document uses `PSTricks` for graphics, follow these additional steps to ensure proper compilation:

### **Convert to PDF**
`PSTricks` requires special handling as it relies on PostScript. Use the following sequence to compile your `.tex` file:

```bash
latex file.tex
dvips file.dvi -o file.ps
ps2pdf file.ps file.pdf
```


### **Debugging PSTricks Issues**
If you encounter errors like unknown tokens or failed PostScript commands, ensure:
   - You're using `dvips` to handle DVI files with embedded PostScript.
   - All required packages (e.g., `pstricks`, `pst-plot`) are installed in your LaTeX distribution.
   - Your LaTeX distribution is up to date.

---

## Notes

Here are some useful tips for working with LaTeX and converting documents:

- **From Word Documents (`.doc`/`.docx`)**: Use Google Docs to export the document as RTF format, then convert the RTF file to LaTeX using `rtf2latex2e`.

- **LaTeX Debugging**: If the build fails, use `make ssh` to open a Docker container and manually compile the file using:
  ```bash
  pdflatex test.tex
