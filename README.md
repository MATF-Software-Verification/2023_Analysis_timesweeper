# 2023_Analysis_timesweeper
## Informacije o projektu koji se analizira
- Projekat koji se analizira se zove **Timesweeper** i može se pronaći na linku: https://gitlab.com/matf-bg-ac-rs/course-rs/projects-2020-2021/06-timesweeper
- Projekat je bio urađen za kurs "Razvoj softvera" u QtCreator razvojnom okruženju (jezik C++)
- Projekat predstavlja 2D platformer igricu u kojoj igrač putuje kroz portale koji ga vode kroz vreme kako bi zaustavio zle vanzemaljce koji su rasprostanjeni svuda po vremenu
## Uvod u analizu
- Analiza se vrši nad main granom projekta i to nad commit-om čiji je SHA: b1b27d201f6a60a855cb1a98c9624a16a6153951
- Analiza će se vršiti pomoću alata pokrenutih iz **terminala** kao i alatima pokrenutih direktno iz **QtCreator** okruženja
- Načini verifikacije koji su upotrebljeni:
  - **UnitTest** - pomoću QtTest biblioteke
  - **Gcov i Lcov** - za proveru pokrivenosti koda testovima
  - **Memcheck** - za proveru upotrebe i curenja memorije
  - **Massif** - za proveru upotreba hipa i steka
  - **Clang-Tidy i Clazy** - za statičku analizu koda
## Zaključak
- Da sumiramo koji su problemi najuočljivi na ovom projektu:
  - **Curenje memorije** - projekat praktično nema upotrebu _delete_ i sličnih funkcija za oslobađanje memorije i često se može pronaći gubljenje reference na kreirane objekte
  - **Manjak testova** - ovo je moguće da je do činjenice što se obično prave odvojeni projekti za testiranje, ali nikakvi testovi nisu bili prisutni
  - **Nečitkost koda** - veliki broj elemenata koji otežavaju čitanje koda počevši od magičnih brojeva pa do komplikovanih i preopširnih metoda
  - **Velika spregnutost** - kod nije baš najbolje izdovjen u logičke celine, veliki deo celina imaju neku međusobnu zavisnost
