To create a new presentation within an repository from this one:

1. Create a new repository or use an existing one which includes
   the presentaion.

2. Clone the dummy repository into that repo:

    ```
    git clone https://github.com/compstat-lmu/presentation_dummy.git
    ```

3. Remove any git files from the `presentation_dummy` directory (if existing).

4. Clone `latex-math` (if desired). You can clone `latex-math` into the 
   `presentation_dummy` or your main repository, just make sure that `latex-math` 
   has an entry within the `.gitignore`:

    ```
    git clone https://github.com/compstat-lmu/latex-math
    ```

5. Use the `presentation_dummy/demo_slides.Rnw` as template and adjust it to your needs.

**Important:**

- The demo slides won't compile without `latex-math`

- Include required math chunks from `latex-math`

- If you want to improve something in `latex-math` make a PR in the repo

- Don't change `latex-math` files, add and overwrite commands in `header.tex`
