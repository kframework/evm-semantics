requires "edsl.md"

module VERIFICATION
    imports EDSL

  // ########################
  // Placeholders
  // ########################

    // TODO: should these be here or in tests/specs/opcodes/create-spec.k?
    //       see comment at beginning of that file.
    syntax Int ::= "#memStart" [function]
                 | "#memWidth" [function]

    syntax Memory ::= "#mapWithCode" [function]

  // ########################
  // Buffer Reasoning
  // ########################

    syntax ByteArray ::= "#generatedCode" [function]
 // ------------------------------------------------
    // This rule is used to avoid complicated memory allocation gas cost.
    // when doing actual proof, the rule is no longer needed 
    // as #generatedCode will be a concrete byte array.
    rule #sizeByteArray(#generatedCode) => 0 [simplification]

  // ########################
  // Arithmetic
  // ########################

    rule I -Int 0 => I [simplification]

    rule 0 +Int I => I [simplification]

    rule I +Int 0 => I [simplification]

    rule chop(I) => I  requires 0 <=Int I andBool I <Int pow256 [simplification]

    rule 0 <=Int #sizeWordStack ( _  , N ) => true                             requires 0  <=Int N [simplification, smt-lemma]
    rule         #sizeWordStack ( WS , N ) => N +Int #sizeWordStack ( WS , 0 ) requires N =/=Int 0 [simplification]

endmodule
