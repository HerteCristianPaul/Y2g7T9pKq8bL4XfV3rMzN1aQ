# Reglator Interactiv pentru Luminozitate și Contrast Imagine

Această aplicație Python îți permite să ajustezi interactiv luminozitatea și contrastul unei imagini prin tragerea mouse-ului. Folosește OpenCV pentru procesarea și afișarea imaginii.

---

## Cuprins

- [Funcționalități](#funcționalități)
- [Cum Funcționează](#cum-funcționează)
- [Instalare](#instalare)
  - [Pe Linux/macOS](#pe-linuxmacos)
  - [Pe Windows (PowerShell)](#pe-windows-powershell)
- [Cerințe proiect](#cerințe-proiect)
- [Tema: P2. "Mouse drag"](#tema-p2-mouse-drag)

---

## Funcționalități

- Încarcă o imagine și o afișează într-o fereastră.
- Ajustează luminozitatea prin tragerea mouse-ului stânga/dreapta.
- Ajustează contrastul prin tragerea mouse-ului sus/jos.
- Salvează imaginea modificată apăsând tasta **s**.
- Iese din aplicație apăsând tasta **ESC**.
- Mesaje clare în consolă pentru feedback și erori.

---

## Cum Funcționează

- La apăsarea butonului stâng al mouse-ului se reține poziția inițială a cursorului.
- Pe durata tragere cu butonul stâng apăsat:
  - Mișcarea orizontală modifică luminozitatea.
  - Mișcarea verticală modifică contrastul.
- Imaginea se actualizează în timp real pe măsură ce tragi.
- Salvarea se face apăsând tasta **s**, care salvează imaginea modificată pe disc.

---

## Instalare

### Cerințe preliminare

- Python 3.7 sau versiune superioară
- Orice editor de text sau IDE (ex: VS Code, PyCharm)

### Instalarea dependențelor folosind mediu virtual (venv)

Este recomandat să folosești un mediu virtual pentru a izola dependențele proiectului.

---

### Pe Linux/macOS

1. Deschide terminalul.
2. Navighează în folderul proiectului.
3. Creează un mediu virtual:

    ```bash
    python3 -m venv venv
    ```

4. Activează mediul virtual:

    ```bash
    source venv/bin/activate
    ```

5. Instalează dependențele:

    ```bash
    pip install opencv-python numpy colorama
    ```

6. Rulează programul:

    ```bash
    python main.py
    ```

---

### Pe Windows (PowerShell)

1. Deschide PowerShell.
2. Navighează în folderul proiectului.
3. Creează un mediu virtual:

    ```powershell
    python -m venv venv
    ```

4. Activează mediul virtual:

    ```powershell
    .\venv\Scripts\Activate.ps1
    ```

    > Dacă întâmpini probleme de permisiuni, rulați această comandă pentru a permite temporar scripturi pentru sesiunea 
   > curentă:

    ```powershell
   Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
    ```

5. Instalează dependențele:

    ```powershell
    pip install opencv-python numpy colorama
    ```

6. Rulează programul:

    ```powershell
    python main.py
    ```

---

## Cerințe proiect

- **Implementați una din temele din fișierul atașat, conform alocării rezultate în urma distribuirii oficiale a temelor.**
- **Puteți folosi orice limbaj de programare doriți.**
- Este important să implementați voi direct procesările necesare, la nivel de pixel, **fără să folosiți funcții de bibliotecă** pentru ajustarea luminozității, contrastului sau alte efecte.  
  - Permis: funcții de bibliotecă doar pentru:
    - Încărcare imagine din fișier
    - Salvare imagine în fișier
    - Afișare imagine pe ecran
- Procesările la nivel de pixel trebuie implementate explicit în program.
- Nu este permisă utilizarea funcțiilor din bibliotecă pentru ajustări de luminozitate/contrast sau combinații de transparență.
- Obiectivul este o implementare **corectă**, destinată **înțelegerii** operațiilor asociate.
- Rezultatul livrabil:  
  - **Codul sursă** al programului  
  - **Imaginile de test**
- Dacă limbajul ales este cu multe fișiere (ex: C# în Visual Studio SLN), **atașați o arhivă ZIP** care conține pachetul de surse și imaginile de test.
- Dacă limbajul ales are un singur fișier sursă (ex: Javascript), **NU este necesară arhiva**. Atașați direct fișierul sursă și imaginile.
- Dacă atașați arhivă, folosiți **doar ZIP**.
- Funcționarea corectă se demonstrează prin prezentare „în plen” (screen-sharing, dacă prezentarea este online).

---

## Tema: P2. "Mouse drag"

- Este un program pentru ajustare luminozitate/contrast folosind un mecanism confortabil bazat pe **mouse-drag** (sau **finger-drag** pe o platformă mobilă).
- Se încarcă o imagine **JPG**.
- Aplicarea unei manevre de tip „drag” pe imagine corectează:
  - **Luminozitatea** proporțional cu deplasarea orizontală (stânga-dreapta)
  - **Contrastul** proporțional cu deplasarea verticală (sus-jos)
- Imaginea se ajustează **în timp real**, cât timp butonul de mouse este apăsat.
- Clarificare:  
  - Dacă efectuezi o manevră „drag” diagonal dreapta-jos, apoi revii la punctul de plecare **fără să eliberezi butonul**, imaginea va fi mai luminoasă și cu mai mult contrast proporțional cu deplasarea, apoi va reveni la aspectul inițial.
  - Dacă efectuezi o manevră „drag la stânga” și eliberezi, imaginea va pierde din luminozitate și va rămâne așa.
- **Observație:** Dacă există dificultăți cu tratarea evenimentelor de mouse, se acceptă și două slidere (luminozitate/contrast) plus un buton „aplică”.
- **Există un buton pentru salvarea imaginii modificate în fișier.**
