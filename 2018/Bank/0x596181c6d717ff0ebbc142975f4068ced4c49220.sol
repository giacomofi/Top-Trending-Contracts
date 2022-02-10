['pragma solidity ^0.4.23;\n', '\n', 'contract ZethrUtils {\n', '  using SafeMath for uint;\n', '\n', '  Zethr constant internal              ZETHR = Zethr(0xD48B633045af65fF636F3c6edd744748351E020D);\n', '\n', '  /*=====================================\n', '  =            CONSTANTS                =\n', '  =====================================*/\n', '\n', '  uint8 constant public                decimals              = 18;\n', '\n', '  uint constant internal               tokenPriceInitial_    = 0.000653 ether;\n', '  uint constant internal               magnitude             = 2**64;\n', '\n', '  uint constant internal               icoHardCap            = 250 ether;\n', '  uint constant internal               addressICOLimit       = 1   ether;\n', '  uint constant internal               icoMinBuyIn           = 0.1 finney;\n', '  uint constant internal               icoMaxGasPrice        = 50000000000 wei;\n', '\n', '  uint constant internal               MULTIPLIER            = 9615;\n', '\n', '  uint constant internal               MIN_ETH_BUYIN         = 0.0001 ether;\n', '  uint constant internal               MIN_TOKEN_SELL_AMOUNT = 0.0001 ether;\n', '  uint constant internal               MIN_TOKEN_TRANSFER    = 1e10;\n', '  uint constant internal               referrer_percentage   = 25;\n', '\n', '  /*=======================================\n', '  =            PUBLIC FUNCTIONS           =\n', '  =======================================*/\n', '\n', '  function tokensToEthereum_1(uint _tokens, uint tokenSupply)\n', '  public\n', '  view\n', '  returns(uint, uint)\n', '  {\n', '    // First, separate out the sell into two segments:\n', '    //  1) the amount of tokens selling at the ICO price.\n', '    //  2) the amount of tokens selling at the variable (pyramid) price\n', '    uint tokensToSellAtICOPrice = 0;\n', '    uint tokensToSellAtVariablePrice = 0;\n', '\n', '    uint tokensMintedDuringICO = ZETHR.tokensMintedDuringICO();\n', '\n', '    if (tokenSupply <= tokensMintedDuringICO) {\n', '      // Option One: All the tokens sell at the ICO price.\n', '      tokensToSellAtICOPrice = _tokens;\n', '\n', '    } else if (tokenSupply > tokensMintedDuringICO && tokenSupply - _tokens >= tokensMintedDuringICO) {\n', '      // Option Two: All the tokens sell at the variable price.\n', '      tokensToSellAtVariablePrice = _tokens;\n', '\n', '    } else if (tokenSupply > tokensMintedDuringICO && tokenSupply - _tokens < tokensMintedDuringICO) {\n', '      // Option Three: Some tokens sell at the ICO price, and some sell at the variable price.\n', '      tokensToSellAtVariablePrice = tokenSupply.sub(tokensMintedDuringICO);\n', '      tokensToSellAtICOPrice      = _tokens.sub(tokensToSellAtVariablePrice);\n', '\n', '    } else {\n', '      // Option Four: Should be impossible, and the compiler should optimize it out of existence.\n', '      revert();\n', '    }\n', '\n', '    // Sanity check:\n', '    assert(tokensToSellAtVariablePrice + tokensToSellAtICOPrice == _tokens);\n', '\n', '    return (tokensToSellAtICOPrice, tokensToSellAtVariablePrice);\n', '  }\n', '\n', '  function tokensToEthereum_2(uint tokensToSellAtICOPrice)\n', '  public\n', '  pure\n', '  returns(uint)\n', '  {\n', '    // Track how much Ether we get from selling at each price function:\n', '    uint ethFromICOPriceTokens = 0;\n', '\n', '    // Now, actually calculate:\n', '\n', '    if (tokensToSellAtICOPrice != 0) {\n', '\n', '      /* Here, unlike the sister equation in ethereumToTokens, we DON&#39;T need to multiply by 1e18, since\n', '         we will be passed in an amount of tokens to sell that&#39;s already at the 18-decimal precision.\n', '         We need to divide by 1e18 or we&#39;ll have too much Ether. */\n', '\n', '      ethFromICOPriceTokens = tokensToSellAtICOPrice.mul(tokenPriceInitial_).div(1e18);\n', '    }\n', '\n', '    return ethFromICOPriceTokens;\n', '  }\n', '\n', '  function tokensToEthereum_3(uint tokensToSellAtVariablePrice, uint tokenSupply)\n', '  public\n', '  pure\n', '  returns(uint)\n', '  {\n', '    // Track how much Ether we get from selling at each price function:\n', '    uint ethFromVarPriceTokens = 0;\n', '\n', '    // Now, actually calculate:\n', '\n', '    if (tokensToSellAtVariablePrice != 0) {\n', '\n', '      /* Note: Unlike the sister function in ethereumToTokens, we don&#39;t have to calculate any "virtual" token count.\n', '         This is because in sells, we sell the variable price tokens **first**, and then we sell the ICO-price tokens.\n', '         Thus there isn&#39;t any weird stuff going on with the token supply.\n', '\n', '         We have the equations for total investment above; note that this is for TOTAL.\n', '         To get the eth received from this sell, we calculate the new total investment after this sell.\n', '         Note that we divide by 1e6 here as the inverse of multiplying by 1e6 in ethereumToTokens. */\n', '\n', '      uint investmentBefore = toPowerOfThreeHalves(tokenSupply.div(MULTIPLIER * 1e6)).mul(2).div(3);\n', '      uint investmentAfter  = toPowerOfThreeHalves((tokenSupply - tokensToSellAtVariablePrice).div(MULTIPLIER * 1e6)).mul(2).div(3);\n', '\n', '      ethFromVarPriceTokens = investmentBefore.sub(investmentAfter);\n', '    }\n', '\n', '    return ethFromVarPriceTokens;\n', '  }\n', '\n', '  // How much Ether we get from selling N tokens\n', '  function tokensToEthereum_(uint _tokens, uint tokenSupply)\n', '  public\n', '  view\n', '  returns(uint)\n', '  {\n', '    require (_tokens >= MIN_TOKEN_SELL_AMOUNT, "Tried to sell too few tokens.");\n', '\n', '    /*\n', '     *  i = investment, p = price, t = number of tokens\n', '     *\n', '     *  i_current = p_initial * t_current                   (for t_current <= t_initial)\n', '     *  i_current = i_initial + (2/3)(t_current)^(3/2)      (for t_current >  t_initial)\n', '     *\n', '     *  t_current = i_current / p_initial                   (for i_current <= i_initial)\n', '     *  t_current = t_initial + ((3/2)(i_current))^(2/3)    (for i_current >  i_initial)\n', '     */\n', '\n', '    uint tokensToSellAtICOPrice;\n', '    uint tokensToSellAtVariablePrice;\n', '\n', '    (tokensToSellAtICOPrice, tokensToSellAtVariablePrice) = tokensToEthereum_1(_tokens, tokenSupply);\n', '\n', '    uint ethFromICOPriceTokens = tokensToEthereum_2(tokensToSellAtICOPrice);\n', '    uint ethFromVarPriceTokens = tokensToEthereum_3(tokensToSellAtVariablePrice, tokenSupply);\n', '\n', '    uint totalEthReceived = ethFromVarPriceTokens + ethFromICOPriceTokens;\n', '\n', '    assert(totalEthReceived > 0);\n', '    return totalEthReceived;\n', '  }\n', '\n', '  /*=======================\n', '   =   MATHS FUNCTIONS    =\n', '   ======================*/\n', '\n', '  function toPowerOfThreeHalves(uint x) public pure returns (uint) {\n', '    // m = 3, n = 2\n', '    // sqrt(x^3)\n', '    return sqrt(x**3);\n', '  }\n', '\n', '  function toPowerOfTwoThirds(uint x) public pure returns (uint) {\n', '    // m = 2, n = 3\n', '    // cbrt(x^2)\n', '    return cbrt(x**2);\n', '  }\n', '\n', '  function sqrt(uint x) public pure returns (uint y) {\n', '    uint z = (x + 1) / 2;\n', '    y = x;\n', '    while (z < y) {\n', '      y = z;\n', '      z = (x / z + z) / 2;\n', '    }\n', '  }\n', '\n', '  function cbrt(uint x) public pure returns (uint y) {\n', '    uint z = (x + 1) / 3;\n', '    y = x;\n', '    while (z < y) {\n', '      y = z;\n', '      z = (x / (z*z) + 2 * z) / 3;\n', '    }\n', '  }\n', '}\n', '\n', '/*=======================\n', ' =     INTERFACES       =\n', ' ======================*/\n', '\n', 'contract Zethr {\n', '  uint public                          stakingRequirement;\n', '  uint public                          tokensMintedDuringICO;\n', '}\n', '\n', '// Think it&#39;s safe to say y&#39;all know what this is.\n', '\n', 'library SafeMath {\n', '\n', '  function mul(uint a, uint b) internal pure returns (uint) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint a, uint b) internal pure returns (uint) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint a, uint b) internal pure returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint a, uint b) internal pure returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}']