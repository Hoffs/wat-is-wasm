# wat is wasm

Experimenting with WebAssembly and its textual representation (WAT).

Most examples are based on code provided by [this article](https://surma.dev/things/raw-wasm/).

FizzBuzz implementation is done entirely by just by reading said article and [WASM W3C Page](https://webassembly.github.io/spec/core/bikeshed/index.html).


## To run

Compiled WAT/WAST is already included in the repository, but to self compile [WebAssembly Binary Toolkit](https://github.com/WebAssembly/wabt) can be used.

Examples themselves are loaded in `index.html`, so to view the examples just serve the current directory using your favorite method, e.g. using node:

```
npx serve
```
