add_mlir_dialect_library(MLIRMemRefUtils
  MemRefUtils.cpp

  ADDITIONAL_HEADER_DIRS
  ${PROJECT_SOURCE_DIR}/inlude/mlir/Dialect/MemRef/Utils

  LINK_LIBS PUBLIC
  MLIRIR
  MLIRAffineDialect
  MLIRArithUtils
)
