['pragma solidity ^0.4.11;\n', '\n', 'contract AddressRegex {\n', '  struct State {\n', '    bool accepts;\n', '    function (byte) constant internal returns (State memory) func;\n', '  }\n', '\n', '  string public constant regex = "0x[0-9a-fA-F]{40}";\n', '\n', '  function s0(byte c) constant internal returns (State memory) {\n', '    c = c;\n', '    return State(false, s0);\n', '  }\n', '\n', '  function s1(byte c) constant internal returns (State memory) {\n', '    if (c == 48) {\n', '      return State(false, s2);\n', '    }\n', '\n', '    return State(false, s0);\n', '  }\n', '\n', '  function s2(byte c) constant internal returns (State memory) {\n', '    if (c == 120) {\n', '      return State(false, s3);\n', '    }\n', '\n', '    return State(false, s0);\n', '  }\n', '\n', '  function s3(byte c) constant internal returns (State memory) {\n', '    if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {\n', '      return State(false, s4);\n', '    }\n', '\n', '    return State(false, s0);\n', '  }\n', '\n', '  function s4(byte c) constant internal returns (State memory) {\n', '    if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {\n', '      return State(false, s5);\n', '    }\n', '\n', '    return State(false, s0);\n', '  }\n', '\n', '  function s5(byte c) constant internal returns (State memory) {\n', '    if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {\n', '      return State(false, s6);\n', '    }\n', '\n', '    return State(false, s0);\n', '  }\n', '\n', '  function s6(byte c) constant internal returns (State memory) {\n', '    if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {\n', '      return State(false, s7);\n', '    }\n', '\n', '    return State(false, s0);\n', '  }\n', '\n', '  function s7(byte c) constant internal returns (State memory) {\n', '    if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {\n', '      return State(false, s8);\n', '    }\n', '\n', '    return State(false, s0);\n', '  }\n', '\n', '  function s8(byte c) constant internal returns (State memory) {\n', '    if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {\n', '      return State(false, s9);\n', '    }\n', '\n', '    return State(false, s0);\n', '  }\n', '\n', '  function s9(byte c) constant internal returns (State memory) {\n', '    if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {\n', '      return State(false, s10);\n', '    }\n', '\n', '    return State(false, s0);\n', '  }\n', '\n', '  function s10(byte c) constant internal returns (State memory) {\n', '    if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {\n', '      return State(false, s11);\n', '    }\n', '\n', '    return State(false, s0);\n', '  }\n', '\n', '  function s11(byte c) constant internal returns (State memory) {\n', '    if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {\n', '      return State(false, s12);\n', '    }\n', '\n', '    return State(false, s0);\n', '  }\n', '\n', '  function s12(byte c) constant internal returns (State memory) {\n', '    if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {\n', '      return State(false, s13);\n', '    }\n', '\n', '    return State(false, s0);\n', '  }\n', '\n', '  function s13(byte c) constant internal returns (State memory) {\n', '    if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {\n', '      return State(false, s14);\n', '    }\n', '\n', '    return State(false, s0);\n', '  }\n', '\n', '  function s14(byte c) constant internal returns (State memory) {\n', '    if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {\n', '      return State(false, s15);\n', '    }\n', '\n', '    return State(false, s0);\n', '  }\n', '\n', '  function s15(byte c) constant internal returns (State memory) {\n', '    if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {\n', '      return State(false, s16);\n', '    }\n', '\n', '    return State(false, s0);\n', '  }\n', '\n', '  function s16(byte c) constant internal returns (State memory) {\n', '    if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {\n', '      return State(false, s17);\n', '    }\n', '\n', '    return State(false, s0);\n', '  }\n', '\n', '  function s17(byte c) constant internal returns (State memory) {\n', '    if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {\n', '      return State(false, s18);\n', '    }\n', '\n', '    return State(false, s0);\n', '  }\n', '\n', '  function s18(byte c) constant internal returns (State memory) {\n', '    if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {\n', '      return State(false, s19);\n', '    }\n', '\n', '    return State(false, s0);\n', '  }\n', '\n', '  function s19(byte c) constant internal returns (State memory) {\n', '    if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {\n', '      return State(false, s20);\n', '    }\n', '\n', '    return State(false, s0);\n', '  }\n', '\n', '  function s20(byte c) constant internal returns (State memory) {\n', '    if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {\n', '      return State(false, s21);\n', '    }\n', '\n', '    return State(false, s0);\n', '  }\n', '\n', '  function s21(byte c) constant internal returns (State memory) {\n', '    if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {\n', '      return State(false, s22);\n', '    }\n', '\n', '    return State(false, s0);\n', '  }\n', '\n', '  function s22(byte c) constant internal returns (State memory) {\n', '    if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {\n', '      return State(false, s23);\n', '    }\n', '\n', '    return State(false, s0);\n', '  }\n', '\n', '  function s23(byte c) constant internal returns (State memory) {\n', '    if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {\n', '      return State(false, s24);\n', '    }\n', '\n', '    return State(false, s0);\n', '  }\n', '\n', '  function s24(byte c) constant internal returns (State memory) {\n', '    if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {\n', '      return State(false, s25);\n', '    }\n', '\n', '    return State(false, s0);\n', '  }\n', '\n', '  function s25(byte c) constant internal returns (State memory) {\n', '    if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {\n', '      return State(false, s26);\n', '    }\n', '\n', '    return State(false, s0);\n', '  }\n', '\n', '  function s26(byte c) constant internal returns (State memory) {\n', '    if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {\n', '      return State(false, s27);\n', '    }\n', '\n', '    return State(false, s0);\n', '  }\n', '\n', '  function s27(byte c) constant internal returns (State memory) {\n', '    if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {\n', '      return State(false, s28);\n', '    }\n', '\n', '    return State(false, s0);\n', '  }\n', '\n', '  function s28(byte c) constant internal returns (State memory) {\n', '    if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {\n', '      return State(false, s29);\n', '    }\n', '\n', '    return State(false, s0);\n', '  }\n', '\n', '  function s29(byte c) constant internal returns (State memory) {\n', '    if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {\n', '      return State(false, s30);\n', '    }\n', '\n', '    return State(false, s0);\n', '  }\n', '\n', '  function s30(byte c) constant internal returns (State memory) {\n', '    if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {\n', '      return State(false, s31);\n', '    }\n', '\n', '    return State(false, s0);\n', '  }\n', '\n', '  function s31(byte c) constant internal returns (State memory) {\n', '    if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {\n', '      return State(false, s32);\n', '    }\n', '\n', '    return State(false, s0);\n', '  }\n', '\n', '  function s32(byte c) constant internal returns (State memory) {\n', '    if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {\n', '      return State(false, s33);\n', '    }\n', '\n', '    return State(false, s0);\n', '  }\n', '\n', '  function s33(byte c) constant internal returns (State memory) {\n', '    if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {\n', '      return State(false, s34);\n', '    }\n', '\n', '    return State(false, s0);\n', '  }\n', '\n', '  function s34(byte c) constant internal returns (State memory) {\n', '    if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {\n', '      return State(false, s35);\n', '    }\n', '\n', '    return State(false, s0);\n', '  }\n', '\n', '  function s35(byte c) constant internal returns (State memory) {\n', '    if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {\n', '      return State(false, s36);\n', '    }\n', '\n', '    return State(false, s0);\n', '  }\n', '\n', '  function s36(byte c) constant internal returns (State memory) {\n', '    if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {\n', '      return State(false, s37);\n', '    }\n', '\n', '    return State(false, s0);\n', '  }\n', '\n', '  function s37(byte c) constant internal returns (State memory) {\n', '    if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {\n', '      return State(false, s38);\n', '    }\n', '\n', '    return State(false, s0);\n', '  }\n', '\n', '  function s38(byte c) constant internal returns (State memory) {\n', '    if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {\n', '      return State(false, s39);\n', '    }\n', '\n', '    return State(false, s0);\n', '  }\n', '\n', '  function s39(byte c) constant internal returns (State memory) {\n', '    if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {\n', '      return State(false, s40);\n', '    }\n', '\n', '    return State(false, s0);\n', '  }\n', '\n', '  function s40(byte c) constant internal returns (State memory) {\n', '    if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {\n', '      return State(false, s41);\n', '    }\n', '\n', '    return State(false, s0);\n', '  }\n', '\n', '  function s41(byte c) constant internal returns (State memory) {\n', '    if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {\n', '      return State(false, s42);\n', '    }\n', '\n', '    return State(false, s0);\n', '  }\n', '\n', '  function s42(byte c) constant internal returns (State memory) {\n', '    if (c >= 48 && c <= 57 || c >= 65 && c <= 70 || c >= 97 && c <= 102) {\n', '      return State(true, s43);\n', '    }\n', '\n', '    return State(false, s0);\n', '  }\n', '\n', '  function s43(byte c) constant internal returns (State memory) {\n', '    // silence unused var warning\n', '    c = c;\n', '\n', '    return State(false, s0);\n', '  }\n', '\n', '  function matches(string input) constant returns (bool) {\n', '    var cur = State(false, s1);\n', '\n', '    for (uint i = 0; i < bytes(input).length; i++) {\n', '      var c = bytes(input)[i];\n', '\n', '      cur = cur.func(c);\n', '    }\n', '\n', '    return cur.accepts;\n', '  }\n', '}']