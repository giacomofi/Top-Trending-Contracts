['// File: contracts/intf/IDODO.sol\n', '\n', '/*\n', '\n', '    Copyright 2020 DODO ZOO.\n', '    SPDX-License-Identifier: Apache-2.0\n', '\n', '*/\n', '\n', 'pragma solidity 0.6.9;\n', 'pragma experimental ABIEncoderV2;\n', '\n', '\n', 'interface IDODO {\n', '    function init(\n', '        address owner,\n', '        address supervisor,\n', '        address maintainer,\n', '        address baseToken,\n', '        address quoteToken,\n', '        address oracle,\n', '        uint256 lpFeeRate,\n', '        uint256 mtFeeRate,\n', '        uint256 k,\n', '        uint256 gasPriceLimit\n', '    ) external;\n', '\n', '    function transferOwnership(address newOwner) external;\n', '\n', '    function claimOwnership() external;\n', '\n', '    function sellBaseToken(\n', '        uint256 amount,\n', '        uint256 minReceiveQuote,\n', '        bytes calldata data\n', '    ) external returns (uint256);\n', '\n', '    function buyBaseToken(\n', '        uint256 amount,\n', '        uint256 maxPayQuote,\n', '        bytes calldata data\n', '    ) external returns (uint256);\n', '\n', '    function querySellBaseToken(uint256 amount) external view returns (uint256 receiveQuote);\n', '\n', '    function queryBuyBaseToken(uint256 amount) external view returns (uint256 payQuote);\n', '\n', '    function depositBaseTo(address to, uint256 amount) external returns (uint256);\n', '\n', '    function withdrawBase(uint256 amount) external returns (uint256);\n', '\n', '    function withdrawAllBase() external returns (uint256);\n', '\n', '    function depositQuoteTo(address to, uint256 amount) external returns (uint256);\n', '\n', '    function withdrawQuote(uint256 amount) external returns (uint256);\n', '\n', '    function withdrawAllQuote() external returns (uint256);\n', '\n', '    function _BASE_CAPITAL_TOKEN_() external returns (address);\n', '\n', '    function _QUOTE_CAPITAL_TOKEN_() external returns (address);\n', '\n', '    function _BASE_TOKEN_() external returns (address);\n', '\n', '    function _QUOTE_TOKEN_() external returns (address);\n', '\n', '    function _R_STATUS_() external view returns (uint8);\n', '\n', '    function _QUOTE_BALANCE_() external view returns (uint256);\n', '\n', '    function _BASE_BALANCE_() external view returns (uint256);\n', '\n', '    function _K_() external view returns (uint256);\n', '\n', '    function _MT_FEE_RATE_() external view returns (uint256);\n', '\n', '    function _LP_FEE_RATE_() external view returns (uint256);\n', '\n', '    function getExpectedTarget() external view returns (uint256 baseTarget, uint256 quoteTarget);\n', '\n', '    function getOraclePrice() external view returns (uint256);\n', '}\n', '\n', '\n', '// File: contracts/lib/SafeMath.sol\n', '\n', '/*\n', '\n', '    Copyright 2020 DODO ZOO.\n', '\n', '*/\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @author DODO Breeder\n', ' *\n', ' * @notice Math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "MUL_ERROR");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "DIVIDING_ERROR");\n', '        return a / b;\n', '    }\n', '\n', '    function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 quotient = div(a, b);\n', '        uint256 remainder = a - quotient * b;\n', '        if (remainder > 0) {\n', '            return quotient + 1;\n', '        } else {\n', '            return quotient;\n', '        }\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SUB_ERROR");\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "ADD_ERROR");\n', '        return c;\n', '    }\n', '\n', '    function sqrt(uint256 x) internal pure returns (uint256 y) {\n', '        uint256 z = x / 2 + 1;\n', '        y = x;\n', '        while (z < y) {\n', '            y = z;\n', '            z = (x / z + z) / 2;\n', '        }\n', '    }\n', '}\n', '\n', '\n', '// File: contracts/lib/DecimalMath.sol\n', '\n', '/*\n', '\n', '    Copyright 2020 DODO ZOO.\n', '\n', '*/\n', '\n', '/**\n', ' * @title DecimalMath\n', ' * @author DODO Breeder\n', ' *\n', ' * @notice Functions for fixed point number with 18 decimals\n', ' */\n', 'library DecimalMath {\n', '    using SafeMath for uint256;\n', '\n', '    uint256 constant ONE = 10**18;\n', '\n', '    function mul(uint256 target, uint256 d) internal pure returns (uint256) {\n', '        return target.mul(d) / ONE;\n', '    }\n', '\n', '    function mulCeil(uint256 target, uint256 d) internal pure returns (uint256) {\n', '        return target.mul(d).divCeil(ONE);\n', '    }\n', '\n', '    function divFloor(uint256 target, uint256 d) internal pure returns (uint256) {\n', '        return target.mul(ONE).div(d);\n', '    }\n', '\n', '    function divCeil(uint256 target, uint256 d) internal pure returns (uint256) {\n', '        return target.mul(ONE).divCeil(d);\n', '    }\n', '}\n', '\n', '\n', '// File: contracts/lib/DODOMath.sol\n', '\n', '/*\n', '\n', '    Copyright 2020 DODO ZOO.\n', '\n', '*/\n', '\n', '/**\n', ' * @title DODOMath\n', ' * @author DODO Breeder\n', ' *\n', ' * @notice Functions for complex calculating. Including ONE Integration and TWO Quadratic solutions\n', ' */\n', 'library DODOMath {\n', '    using SafeMath for uint256;\n', '\n', '    /*\n', '        Integrate dodo curve fron V1 to V2\n', '        require V0>=V1>=V2>0\n', '        res = (1-k)i(V1-V2)+ikV0*V0(1/V2-1/V1)\n', '        let V1-V2=delta\n', '        res = i*delta*(1-k+k(V0^2/V1/V2))\n', '    */\n', '    function _GeneralIntegrate(\n', '        uint256 V0,\n', '        uint256 V1,\n', '        uint256 V2,\n', '        uint256 i,\n', '        uint256 k\n', '    ) internal pure returns (uint256) {\n', '        uint256 fairAmount = DecimalMath.mul(i, V1.sub(V2)); // i*delta\n', '        uint256 V0V0V1V2 = DecimalMath.divCeil(V0.mul(V0).div(V1), V2);\n', '        uint256 penalty = DecimalMath.mul(k, V0V0V1V2); // k(V0^2/V1/V2)\n', '        return DecimalMath.mul(fairAmount, DecimalMath.ONE.sub(k).add(penalty));\n', '    }\n', '\n', '    /*\n', '        The same with integration expression above, we have:\n', '        i*deltaB = (Q2-Q1)*(1-k+kQ0^2/Q1/Q2)\n', '        Given Q1 and deltaB, solve Q2\n', '        This is a quadratic function and the standard version is\n', '        aQ2^2 + bQ2 + c = 0, where\n', '        a=1-k\n', '        -b=(1-k)Q1-kQ0^2/Q1+i*deltaB\n', '        c=-kQ0^2\n', '        and Q2=(-b+sqrt(b^2+4(1-k)kQ0^2))/2(1-k)\n', '        note: another root is negative, abondan\n', '        if deltaBSig=true, then Q2>Q1\n', '        if deltaBSig=false, then Q2<Q1\n', '    */\n', '    function _SolveQuadraticFunctionForTrade(\n', '        uint256 Q0,\n', '        uint256 Q1,\n', '        uint256 ideltaB,\n', '        bool deltaBSig,\n', '        uint256 k\n', '    ) internal pure returns (uint256) {\n', '        // calculate -b value and sig\n', '        // -b = (1-k)Q1-kQ0^2/Q1+i*deltaB\n', '        uint256 kQ02Q1 = DecimalMath.mul(k, Q0).mul(Q0).div(Q1); // kQ0^2/Q1\n', '        uint256 b = DecimalMath.mul(DecimalMath.ONE.sub(k), Q1); // (1-k)Q1\n', '        bool minusbSig = true;\n', '        if (deltaBSig) {\n', '            b = b.add(ideltaB); // (1-k)Q1+i*deltaB\n', '        } else {\n', '            kQ02Q1 = kQ02Q1.add(ideltaB); // i*deltaB+kQ0^2/Q1\n', '        }\n', '        if (b >= kQ02Q1) {\n', '            b = b.sub(kQ02Q1);\n', '            minusbSig = true;\n', '        } else {\n', '            b = kQ02Q1.sub(b);\n', '            minusbSig = false;\n', '        }\n', '\n', '        // calculate sqrt\n', '        uint256 squareRoot = DecimalMath.mul(\n', '            DecimalMath.ONE.sub(k).mul(4),\n', '            DecimalMath.mul(k, Q0).mul(Q0)\n', '        ); // 4(1-k)kQ0^2\n', '        squareRoot = b.mul(b).add(squareRoot).sqrt(); // sqrt(b*b+4(1-k)kQ0*Q0)\n', '\n', '        // final res\n', '        uint256 denominator = DecimalMath.ONE.sub(k).mul(2); // 2(1-k)\n', '        uint256 numerator;\n', '        if (minusbSig) {\n', '            numerator = b.add(squareRoot);\n', '        } else {\n', '            numerator = squareRoot.sub(b);\n', '        }\n', '\n', '        if (deltaBSig) {\n', '            return DecimalMath.divFloor(numerator, denominator);\n', '        } else {\n', '            return DecimalMath.divCeil(numerator, denominator);\n', '        }\n', '    }\n', '\n', '    /*\n', '        Start from the integration function\n', '        i*deltaB = (Q2-Q1)*(1-k+kQ0^2/Q1/Q2)\n', '        Assume Q2=Q0, Given Q1 and deltaB, solve Q0\n', '        let fairAmount = i*deltaB\n', '    */\n', '    function _SolveQuadraticFunctionForTarget(\n', '        uint256 V1,\n', '        uint256 k,\n', '        uint256 fairAmount\n', '    ) internal pure returns (uint256 V0) {\n', '        // V0 = V1+V1*(sqrt-1)/2k\n', '        uint256 sqrt = DecimalMath.divCeil(DecimalMath.mul(k, fairAmount).mul(4), V1);\n', '        sqrt = sqrt.add(DecimalMath.ONE).mul(DecimalMath.ONE).sqrt();\n', '        uint256 premium = DecimalMath.divCeil(sqrt.sub(DecimalMath.ONE), k.mul(2));\n', '        // V0 is greater than or equal to V1 according to the solution\n', '        return DecimalMath.mul(V1, DecimalMath.ONE.add(premium));\n', '    }\n', '}\n', '\n', '\n', '// File: contracts/helper/DODOSellHelper.sol\n', '\n', '/*\n', '\n', '    Copyright 2020 DODO ZOO.\n', '\n', '*/\n', '\n', 'contract DODOSellHelper {\n', '    using SafeMath for uint256;\n', '\n', '    enum RStatus {ONE, ABOVE_ONE, BELOW_ONE}\n', '\n', '    uint256 constant ONE = 10**18;\n', '\n', '    struct DODOState {\n', '        uint256 oraclePrice;\n', '        uint256 K;\n', '        uint256 B;\n', '        uint256 Q;\n', '        uint256 baseTarget;\n', '        uint256 quoteTarget;\n', '        RStatus rStatus;\n', '    }\n', '\n', '    function querySellBaseToken(address dodo, uint256 amount) public view returns (uint256) {\n', '        return IDODO(dodo).querySellBaseToken(amount);\n', '    }\n', '\n', '    function querySellQuoteToken(address dodo, uint256 amount) public view returns (uint256) {\n', '        DODOState memory state;\n', '        (state.baseTarget, state.quoteTarget) = IDODO(dodo).getExpectedTarget();\n', '        state.rStatus = RStatus(IDODO(dodo)._R_STATUS_());\n', '        state.oraclePrice = IDODO(dodo).getOraclePrice();\n', '        state.Q = IDODO(dodo)._QUOTE_BALANCE_();\n', '        state.B = IDODO(dodo)._BASE_BALANCE_();\n', '        state.K = IDODO(dodo)._K_();\n', '\n', '        uint256 boughtAmount;\n', '        // Determine the status (RStatus) and calculate the amount\n', '        // based on the state\n', '        if (state.rStatus == RStatus.ONE) {\n', '            boughtAmount = _ROneSellQuoteToken(amount, state);\n', '        } else if (state.rStatus == RStatus.ABOVE_ONE) {\n', '            boughtAmount = _RAboveSellQuoteToken(amount, state);\n', '        } else {\n', '            uint256 backOneBase = state.B.sub(state.baseTarget);\n', '            uint256 backOneQuote = state.quoteTarget.sub(state.Q);\n', '            if (amount <= backOneQuote) {\n', '                boughtAmount = _RBelowSellQuoteToken(amount, state);\n', '            } else {\n', '                boughtAmount = backOneBase.add(\n', '                    _ROneSellQuoteToken(amount.sub(backOneQuote), state)\n', '                );\n', '            }\n', '        }\n', '        // Calculate fees\n', '        return\n', '            DecimalMath.divFloor(\n', '                boughtAmount,\n', '                DecimalMath.ONE.add(IDODO(dodo)._MT_FEE_RATE_()).add(IDODO(dodo)._LP_FEE_RATE_())\n', '            );\n', '    }\n', '\n', '    function _ROneSellQuoteToken(uint256 amount, DODOState memory state)\n', '        internal\n', '        pure\n', '        returns (uint256 receiveBaseToken)\n', '    {\n', '        uint256 i = DecimalMath.divFloor(ONE, state.oraclePrice);\n', '        uint256 B2 = DODOMath._SolveQuadraticFunctionForTrade(\n', '            state.baseTarget,\n', '            state.baseTarget,\n', '            DecimalMath.mul(i, amount),\n', '            false,\n', '            state.K\n', '        );\n', '        return state.baseTarget.sub(B2);\n', '    }\n', '\n', '    function _RAboveSellQuoteToken(uint256 amount, DODOState memory state)\n', '        internal\n', '        pure\n', '        returns (uint256 receieBaseToken)\n', '    {\n', '        uint256 i = DecimalMath.divFloor(ONE, state.oraclePrice);\n', '        uint256 B2 = DODOMath._SolveQuadraticFunctionForTrade(\n', '            state.baseTarget,\n', '            state.B,\n', '            DecimalMath.mul(i, amount),\n', '            false,\n', '            state.K\n', '        );\n', '        return state.B.sub(B2);\n', '    }\n', '\n', '    function _RBelowSellQuoteToken(uint256 amount, DODOState memory state)\n', '        internal\n', '        pure\n', '        returns (uint256 receiveBaseToken)\n', '    {\n', '        uint256 Q1 = state.Q.add(amount);\n', '        uint256 i = DecimalMath.divFloor(ONE, state.oraclePrice);\n', '        return DODOMath._GeneralIntegrate(state.quoteTarget, Q1, state.Q, i, state.K);\n', '    }\n', '}']