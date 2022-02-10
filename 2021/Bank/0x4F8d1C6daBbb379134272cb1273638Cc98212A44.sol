['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-13\n', '*/\n', '\n', '// File: contracts/lib/XNum.sol\n', '\n', 'pragma solidity 0.5.17;\n', '\n', 'library XNum {\n', '    uint256 public constant BONE = 10**18;\n', '    uint256 public constant MIN_BPOW_BASE = 1 wei;\n', '    uint256 public constant MAX_BPOW_BASE = (2 * BONE) - 1 wei;\n', '    uint256 public constant BPOW_PRECISION = BONE / 10**10;\n', '\n', '    function btoi(uint256 a) internal pure returns (uint256) {\n', '        return a / BONE;\n', '    }\n', '\n', '    function bfloor(uint256 a) internal pure returns (uint256) {\n', '        return btoi(a) * BONE;\n', '    }\n', '\n', '    function badd(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "ERR_ADD_OVERFLOW");\n', '        return c;\n', '    }\n', '\n', '    function bsub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        (uint256 c, bool flag) = bsubSign(a, b);\n', '        require(!flag, "ERR_SUB_UNDERFLOW");\n', '        return c;\n', '    }\n', '\n', '    function bsubSign(uint256 a, uint256 b)\n', '        internal\n', '        pure\n', '        returns (uint256, bool)\n', '    {\n', '        if (a >= b) {\n', '            return (a - b, false);\n', '        } else {\n', '            return (b - a, true);\n', '        }\n', '    }\n', '\n', '    function bmul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c0 = a * b;\n', '        require(a == 0 || c0 / a == b, "ERR_MUL_OVERFLOW");\n', '        uint256 c1 = c0 + (BONE / 2);\n', '        require(c1 >= c0, "ERR_MUL_OVERFLOW");\n', '        uint256 c2 = c1 / BONE;\n', '        return c2;\n', '    }\n', '\n', '    function bdiv(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0, "ERR_DIV_ZERO");\n', '        uint256 c0 = a * BONE;\n', '        require(a == 0 || c0 / a == BONE, "ERR_DIV_INTERNAL"); // bmul overflow\n', '        uint256 c1 = c0 + (b / 2);\n', '        require(c1 >= c0, "ERR_DIV_INTERNAL"); //  badd require\n', '        uint256 c2 = c1 / b;\n', '        return c2;\n', '    }\n', '\n', '    // DSMath.wpow\n', '    function bpowi(uint256 a, uint256 n) internal pure returns (uint256) {\n', '        uint256 z = n % 2 != 0 ? a : BONE;\n', '\n', '        for (n /= 2; n != 0; n /= 2) {\n', '            a = bmul(a, a);\n', '\n', '            if (n % 2 != 0) {\n', '                z = bmul(z, a);\n', '            }\n', '        }\n', '        return z;\n', '    }\n', '\n', '    // Compute b^(e.w) by splitting it into (b^e)*(b^0.w).\n', '    // Use `bpowi` for `b^e` and `bpowK` for k iterations\n', '    // of approximation of b^0.w\n', '    function bpow(uint256 base, uint256 exp) internal pure returns (uint256) {\n', '        require(base >= MIN_BPOW_BASE, "ERR_BPOW_BASE_TOO_LOW");\n', '        require(base <= MAX_BPOW_BASE, "ERR_BPOW_BASE_TOO_HIGH");\n', '\n', '        uint256 whole = bfloor(exp);\n', '        uint256 remain = bsub(exp, whole);\n', '\n', '        uint256 wholePow = bpowi(base, btoi(whole));\n', '\n', '        if (remain == 0) {\n', '            return wholePow;\n', '        }\n', '\n', '        uint256 partialResult = bpowApprox(base, remain, BPOW_PRECISION);\n', '        return bmul(wholePow, partialResult);\n', '    }\n', '\n', '    function bpowApprox(\n', '        uint256 base,\n', '        uint256 exp,\n', '        uint256 precision\n', '    ) internal pure returns (uint256) {\n', '        // term 0:\n', '        uint256 a = exp;\n', '        (uint256 x, bool xneg) = bsubSign(base, BONE);\n', '        uint256 term = BONE;\n', '        uint256 sum = term;\n', '        bool negative = false;\n', '\n', '        // term(k) = numer / denom\n', '        //         = (product(a - i + 1, i=1-->k) * x^k) / (k!)\n', '        // each iteration, multiply previous term by (a-(k-1)) * x / k\n', '        // continue until term is less than precision\n', '        for (uint256 i = 1; term >= precision; i++) {\n', '            uint256 bigK = i * BONE;\n', '            (uint256 c, bool cneg) = bsubSign(a, bsub(bigK, BONE));\n', '            term = bmul(term, bmul(c, x));\n', '            term = bdiv(term, bigK);\n', '            if (term == 0) break;\n', '\n', '            if (xneg) negative = !negative;\n', '            if (cneg) negative = !negative;\n', '            if (negative) {\n', '                sum = bsub(sum, term);\n', '            } else {\n', '                sum = badd(sum, term);\n', '            }\n', '        }\n', '\n', '        return sum;\n', '    }\n', '}\n', '\n', '// File: contracts/lib/XMath.sol\n', '\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU General Public License for more details.\n', '\n', '// You should have received a copy of the GNU General Public License\n', '// along with this program.  If not, see <http://www.gnu.org/licenses/>.\n', '\n', 'pragma solidity 0.5.17;\n', '\n', '\n', 'library XMath {\n', '    using XNum for uint256;\n', '\n', '    uint256 public constant BONE = 10**18;\n', '    uint256 public constant EXIT_ZERO_FEE = 0;\n', '\n', '    /**********************************************************************************************\n', '    // calcSpotPrice                                                                             //\n', '    // sP = spotPrice                                                                            //\n', '    // bI = tokenBalanceIn                ( bI / wI )         1                                  //\n', '    // bO = tokenBalanceOut         sP =  -----------  *  ----------                             //\n', '    // wI = tokenWeightIn                 ( bO / wO )     ( 1 - sF )                             //\n', '    // wO = tokenWeightOut                                                                       //\n', '    // sF = swapFee                                                                              //\n', '    **********************************************************************************************/\n', '    function calcSpotPrice(\n', '        uint256 tokenBalanceIn,\n', '        uint256 tokenWeightIn,\n', '        uint256 tokenBalanceOut,\n', '        uint256 tokenWeightOut,\n', '        uint256 swapFee\n', '    ) public pure returns (uint256 spotPrice) {\n', '        uint256 numer = tokenBalanceIn.bdiv(tokenWeightIn);\n', '        uint256 denom = tokenBalanceOut.bdiv(tokenWeightOut);\n', '        uint256 ratio = numer.bdiv(denom);\n', '        uint256 scale = BONE.bdiv(BONE.bsub(swapFee));\n', '        return (spotPrice = ratio.bmul(scale));\n', '    }\n', '\n', '    /**********************************************************************************************\n', '    // calcOutGivenIn                                                                            //\n', '    // aO = tokenAmountOut                                                                       //\n', '    // bO = tokenBalanceOut                                                                      //\n', '    // bI = tokenBalanceIn              /      /            bI             \\    (wI / wO) \\      //\n', '    // aI = tokenAmountIn    aO = bO * |  1 - | --------------------------  | ^            |     //\n', '    // wI = tokenWeightIn               \\      \\ ( bI + ( aI * ( 1 - sF )) /              /      //\n', '    // wO = tokenWeightOut                                                                       //\n', '    // sF = swapFee                                                                              //\n', '    **********************************************************************************************/\n', '    function calcOutGivenIn(\n', '        uint256 tokenBalanceIn,\n', '        uint256 tokenWeightIn,\n', '        uint256 tokenBalanceOut,\n', '        uint256 tokenWeightOut,\n', '        uint256 tokenAmountIn,\n', '        uint256 swapFee\n', '    ) public pure returns (uint256 tokenAmountOut) {\n', '        uint256 weightRatio;\n', '        if (tokenWeightIn == tokenWeightOut) {\n', '            weightRatio = 1 * BONE;\n', '        } else if (tokenWeightIn >> 1 == tokenWeightOut) {\n', '            weightRatio = 2 * BONE;\n', '        } else {\n', '            weightRatio = tokenWeightIn.bdiv(tokenWeightOut);\n', '        }\n', '        uint256 adjustedIn = BONE.bsub(swapFee);\n', '        adjustedIn = tokenAmountIn.bmul(adjustedIn);\n', '        uint256 y = tokenBalanceIn.bdiv(tokenBalanceIn.badd(adjustedIn));\n', '        uint256 foo;\n', '        if (tokenWeightIn == tokenWeightOut) {\n', '            foo = y;\n', '        } else if (tokenWeightIn >> 1 == tokenWeightOut) {\n', '            foo = y.bmul(y);\n', '        } else {\n', '            foo = y.bpow(weightRatio);\n', '        }\n', '        uint256 bar = BONE.bsub(foo);\n', '        tokenAmountOut = tokenBalanceOut.bmul(bar);\n', '        return tokenAmountOut;\n', '    }\n', '\n', '    /**********************************************************************************************\n', '    // calcInGivenOut                                                                            //\n', '    // aI = tokenAmountIn                                                                        //\n', '    // bO = tokenBalanceOut               /  /     bO      \\    (wO / wI)      \\                 //\n', '    // bI = tokenBalanceIn          bI * |  | ------------  | ^            - 1  |                //\n', '    // aO = tokenAmountOut    aI =        \\  \\ ( bO - aO ) /                   /                 //\n', '    // wI = tokenWeightIn           --------------------------------------------                 //\n', '    // wO = tokenWeightOut                          ( 1 - sF )                                   //\n', '    // sF = swapFee                                                                              //\n', '    **********************************************************************************************/\n', '    function calcInGivenOut(\n', '        uint256 tokenBalanceIn,\n', '        uint256 tokenWeightIn,\n', '        uint256 tokenBalanceOut,\n', '        uint256 tokenWeightOut,\n', '        uint256 tokenAmountOut,\n', '        uint256 swapFee\n', '    ) public pure returns (uint256 tokenAmountIn) {\n', '        uint256 weightRatio;\n', '        if (tokenWeightOut == tokenWeightIn) {\n', '            weightRatio = 1 * BONE;\n', '        } else if (tokenWeightOut >> 1 == tokenWeightIn) {\n', '            weightRatio = 2 * BONE;\n', '        } else {\n', '            weightRatio = tokenWeightOut.bdiv(tokenWeightIn);\n', '        }\n', '        uint256 diff = tokenBalanceOut.bsub(tokenAmountOut);\n', '        uint256 y = tokenBalanceOut.bdiv(diff);\n', '        uint256 foo;\n', '        if (tokenWeightOut == tokenWeightIn) {\n', '            foo = y;\n', '        } else if (tokenWeightOut >> 1 == tokenWeightIn) {\n', '            foo = y.bmul(y);\n', '        } else {\n', '            foo = y.bpow(weightRatio);\n', '        }\n', '        foo = foo.bsub(BONE);\n', '        tokenAmountIn = BONE.bsub(swapFee);\n', '        tokenAmountIn = tokenBalanceIn.bmul(foo).bdiv(tokenAmountIn);\n', '        return tokenAmountIn;\n', '    }\n', '\n', '    /**********************************************************************************************\n', '    // calcPoolOutGivenSingleIn                                                                  //\n', '    // pAo = poolAmountOut         /                                              \\              //\n', '    // tAi = tokenAmountIn        ///      /     //    wI \\      \\\\       \\     wI \\             //\n', '    // wI = tokenWeightIn        //| tAi *| 1 - || 1 - --  | * sF || + tBi \\    --  \\            //\n', '    // tW = totalWeight     pAo=||  \\      \\     \\\\    tW /      //         | ^ tW   | * pS - pS //\n', '    // tBi = tokenBalanceIn      \\\\  ------------------------------------- /        /            //\n', '    // pS = poolSupply            \\\\                    tBi               /        /             //\n', '    // sF = swapFee                \\                                              /              //\n', '    **********************************************************************************************/\n', '    function calcPoolOutGivenSingleIn(\n', '        uint256 tokenBalanceIn,\n', '        uint256 tokenWeightIn,\n', '        uint256 poolSupply,\n', '        uint256 totalWeight,\n', '        uint256 tokenAmountIn,\n', '        uint256 swapFee\n', '    ) public pure returns (uint256 poolAmountOut) {\n', '        // Charge the trading fee for the proportion of tokenAi\n', '        ///  which is implicitly traded to the other pool tokens.\n', '        // That proportion is (1- weightTokenIn)\n', '        // tokenAiAfterFee = tAi * (1 - (1-weightTi) * poolFee);\n', '        uint256 normalizedWeight = tokenWeightIn.bdiv(totalWeight);\n', '        uint256 zaz = BONE.bsub(normalizedWeight).bmul(swapFee);\n', '        uint256 tokenAmountInAfterFee = tokenAmountIn.bmul(BONE.bsub(zaz));\n', '\n', '        uint256 newTokenBalanceIn = tokenBalanceIn.badd(tokenAmountInAfterFee);\n', '        uint256 tokenInRatio = newTokenBalanceIn.bdiv(tokenBalanceIn);\n', '\n', '        // uint newPoolSupply = (ratioTi ^ weightTi) * poolSupply;\n', '        uint256 poolRatio = tokenInRatio.bpow(normalizedWeight);\n', '        uint256 newPoolSupply = poolRatio.bmul(poolSupply);\n', '        poolAmountOut = newPoolSupply.bsub(poolSupply);\n', '        return poolAmountOut;\n', '    }\n', '\n', '    /**********************************************************************************************\n', '    // calcSingleOutGivenPoolIn                                                                  //\n', '    // tAo = tokenAmountOut            /      /                                             \\\\   //\n', '    // bO = tokenBalanceOut           /      // pS - (pAi * (1 - eF)) \\     /    1    \\      \\\\  //\n', '    // pAi = poolAmountIn            | bO - || ----------------------- | ^ | --------- | * b0 || //\n', '    // ps = poolSupply                \\      \\\\          pS           /     \\(wO / tW)/      //  //\n', '    // wI = tokenWeightIn      tAo =   \\      \\                                             //   //\n', '    // tW = totalWeight                    /     /      wO \\       \\                             //\n', '    // sF = swapFee                    *  | 1 - |  1 - ---- | * sF  |                            //\n', '    // eF = exitFee                        \\     \\      tW /       /                             //\n', '    **********************************************************************************************/\n', '    function calcSingleOutGivenPoolIn(\n', '        uint256 tokenBalanceOut,\n', '        uint256 tokenWeightOut,\n', '        uint256 poolSupply,\n', '        uint256 totalWeight,\n', '        uint256 poolAmountIn,\n', '        uint256 swapFee\n', '    ) public pure returns (uint256 tokenAmountOut) {\n', '        uint256 normalizedWeight = tokenWeightOut.bdiv(totalWeight);\n', '        // charge exit fee on the pool token side\n', '        // pAiAfterExitFee = pAi*(1-exitFee)\n', '        uint256 poolAmountInAfterExitFee =\n', '            poolAmountIn.bmul(BONE.bsub(EXIT_ZERO_FEE));\n', '        uint256 newPoolSupply = poolSupply.bsub(poolAmountInAfterExitFee);\n', '        uint256 poolRatio = newPoolSupply.bdiv(poolSupply);\n', '\n', '        // newBalTo = poolRatio^(1/weightTo) * balTo;\n', '        uint256 tokenOutRatio = poolRatio.bpow(BONE.bdiv(normalizedWeight));\n', '        uint256 newTokenBalanceOut = tokenOutRatio.bmul(tokenBalanceOut);\n', '\n', '        uint256 tokenAmountOutBeforeSwapFee =\n', '            tokenBalanceOut.bsub(newTokenBalanceOut);\n', '\n', '        // charge swap fee on the output token side\n', '        //uint tAo = tAoBeforeSwapFee * (1 - (1-weightTo) * swapFee)\n', '        uint256 zaz = BONE.bsub(normalizedWeight).bmul(swapFee);\n', '        tokenAmountOut = tokenAmountOutBeforeSwapFee.bmul(BONE.bsub(zaz));\n', '        return tokenAmountOut;\n', '    }\n', '}']