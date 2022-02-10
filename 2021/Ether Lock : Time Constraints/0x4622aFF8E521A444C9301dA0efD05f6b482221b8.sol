['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.7.3;\n', '\n', 'import "./ICToken.sol";\n', 'import "./IYearn.sol";\n', 'import "./ILendingPoolV2.sol";\n', 'import "./IBasket.sol";\n', 'import "./IATokenV2.sol";\n', 'import "./ICurveZap.sol";\n', 'import "./ICurve.sol";\n', '\n', 'import "./ABDKMath64x64.sol";\n', '\n', 'import "./ERC20.sol";\n', 'import "./IERC20.sol";\n', 'import "./SafeERC20.sol";\n', 'import "./SafeMath.sol";\n', 'import "./Ownable.sol";\n', '\n', 'import "./console.sol";\n', '\n', 'contract BMIZapper is Ownable {\n', '    using SafeERC20 for IERC20;\n', '    using SafeMath for uint256;\n', '\n', '    using ABDKMath64x64 for int128;\n', '    using ABDKMath64x64 for uint256;\n', '\n', '    // Auxillery\n', '    address constant AAVE_LENDING_POOL_V2 = 0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9;\n', '\n', '    // Tokens\n', '\n', '    // BMI\n', '    address public BMI;\n', '\n', '    // Bare\n', '    address constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;\n', '    address constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;\n', '    address constant USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7;\n', '    address constant TUSD = 0x0000000000085d4780B73119b644AE5ecd22b376;\n', '    address constant SUSD = 0x57Ab1ec28D129707052df4dF418D58a2D46d5f51;\n', '    address constant BUSD = 0x4Fabb145d64652a948d72533023f6E7A623C7C53;\n', '    address constant USDP = 0x1456688345527bE1f37E9e627DA0837D6f08C925;\n', '    address constant FRAX = 0x853d955aCEf822Db058eb8505911ED77F175b99e;\n', '    address constant ALUSD = 0xBC6DA0FE9aD5f3b0d58160288917AA56653660E9;\n', '    address constant LUSD = 0x5f98805A4E8be255a32880FDeC7F6728C6568bA0;\n', '    address constant USDN = 0x674C6Ad92Fd080e4004b2312b45f796a192D27a0;\n', '\n', '    // Yearn\n', '    address constant yDAI = 0x19D3364A399d251E894aC732651be8B0E4e85001;\n', '    address constant yUSDC = 0x5f18C75AbDAe578b483E5F43f12a39cF75b973a9;\n', '    address constant yUSDT = 0x7Da96a3891Add058AdA2E826306D812C638D87a7;\n', '    address constant yTUSD = 0x37d19d1c4E1fa9DC47bD1eA12f742a0887eDa74a;\n', '    address constant ySUSD = 0xa5cA62D95D24A4a350983D5B8ac4EB8638887396;\n', '\n', '    // Yearn CRV\n', '    address constant yCRV = 0x4B5BfD52124784745c1071dcB244C6688d2533d3; // Y Pool\n', '    address constant ycrvSUSD = 0x5a770DbD3Ee6bAF2802D29a901Ef11501C44797A;\n', '    address constant ycrvYBUSD = 0x8ee57c05741aA9DB947A744E713C15d4d19D8822;\n', '    address constant ycrvBUSD = 0x6Ede7F19df5df6EF23bD5B9CeDb651580Bdf56Ca;\n', '    address constant ycrvUSDP = 0xC4dAf3b5e2A9e93861c3FBDd25f1e943B8D87417;\n', '    address constant ycrvFRAX = 0xB4AdA607B9d6b2c9Ee07A275e9616B84AC560139;\n', '    address constant ycrvALUSD = 0xA74d4B67b3368E83797a35382AFB776bAAE4F5C8;\n', '    address constant ycrvLUSD = 0x5fA5B62c8AF877CB37031e0a3B2f34A78e3C56A6;\n', '    address constant ycrvUSDN = 0x3B96d491f067912D18563d56858Ba7d6EC67a6fa;\n', '    address constant ycrvIB = 0x27b7b1ad7288079A66d12350c828D3C00A6F07d7;\n', '    address constant ycrvThree = 0x84E13785B5a27879921D6F685f041421C7F482dA;\n', '    address constant ycrvDUSD = 0x30FCf7c6cDfC46eC237783D94Fc78553E79d4E9C;\n', '    address constant ycrvMUSD = 0x8cc94ccd0f3841a468184aCA3Cc478D2148E1757;\n', '    address constant ycrvUST = 0x1C6a9783F812b3Af3aBbf7de64c3cD7CC7D1af44;\n', '\n', '    // Aave\n', '    address constant aDAI = 0x028171bCA77440897B824Ca71D1c56caC55b68A3;\n', '    address constant aUSDC = 0xBcca60bB61934080951369a648Fb03DF4F96263C;\n', '    address constant aUSDT = 0x3Ed3B47Dd13EC9a98b44e6204A523E766B225811;\n', '    address constant aTUSD = 0x101cc05f4A51C0319f570d5E146a8C625198e636;\n', '    address constant aSUSD = 0x6C5024Cd4F8A59110119C56f8933403A539555EB;\n', '\n', '    // Compound\n', '    address constant cDAI = 0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643;\n', '    address constant cUSDC = 0x39AA39c021dfbaE8faC545936693aC917d5E7563;\n', '    address constant cUSDT = 0xf650C3d88D12dB855b8bf7D11Be6C55A4e07dCC9;\n', '    address constant cTUSD = 0x12392F67bdf24faE0AF363c24aC620a2f67DAd86;\n', '\n', '    // Curve\n', '    address constant crvY = 0xdF5e0e81Dff6FAF3A7e52BA697820c5e32D806A8;\n', '    address constant crvYPool = 0x45F783CCE6B7FF23B2ab2D70e416cdb7D6055f51;\n', '    address constant crvYZap = 0xbBC81d23Ea2c3ec7e56D39296F0cbB648873a5d3;\n', '\n', '    address constant crvSUSD = 0xC25a3A3b969415c80451098fa907EC722572917F;\n', '    address constant crvSUSDPool = 0xA5407eAE9Ba41422680e2e00537571bcC53efBfD;\n', '    address constant crvSUSDZap = 0xFCBa3E75865d2d561BE8D220616520c171F12851;\n', '\n', '    address constant crvYBUSD = 0x3B3Ac5386837Dc563660FB6a0937DFAa5924333B;\n', '    address constant crvYBUSDPool = 0x79a8C46DeA5aDa233ABaFFD40F3A0A2B1e5A4F27;\n', '    address constant crvYBUSDZap = 0xb6c057591E073249F2D9D88Ba59a46CFC9B59EdB;\n', '\n', '    address constant crvThree = 0x6c3F90f043a72FA612cbac8115EE7e52BDe6E490;\n', '    address constant crvThreePool = 0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7;\n', '\n', '    address constant crvUSDP = 0x7Eb40E450b9655f4B3cC4259BCC731c63ff55ae6;\n', '    address constant crvUSDPPool = 0x42d7025938bEc20B69cBae5A77421082407f053A;\n', '    address constant crvUSDPZap = 0x3c8cAee4E09296800f8D29A68Fa3837e2dae4940;\n', '\n', '    address constant crvDUSD = 0x3a664Ab939FD8482048609f652f9a0B0677337B9;\n', '    address constant crvDUSDPool = 0x8038C01A0390a8c547446a0b2c18fc9aEFEcc10c;\n', '    address constant crvDUSDZap = 0x61E10659fe3aa93d036d099405224E4Ac24996d0;\n', '\n', '    address constant crvMUSD = 0x1AEf73d49Dedc4b1778d0706583995958Dc862e6;\n', '    address constant crvMUSDPool = 0x8474DdbE98F5aA3179B3B3F5942D724aFcdec9f6;\n', '    address constant crvMUSDZap = 0x803A2B40c5a9BB2B86DD630B274Fa2A9202874C2;\n', '\n', '    address constant crvUST = 0x94e131324b6054c0D789b190b2dAC504e4361b53;\n', '    address constant crvUSTPool = 0x890f4e345B1dAED0367A877a1612f86A1f86985f;\n', '    address constant crvUSTZap = 0xB0a0716841F2Fc03fbA72A891B8Bb13584F52F2d;\n', '\n', '    address constant crvUSDN = 0x4f3E8F405CF5aFC05D68142F3783bDfE13811522;\n', '    address constant crvUSDNPool = 0x0f9cb53Ebe405d49A0bbdBD291A65Ff571bC83e1;\n', '    address constant crvUSDNZap = 0x094d12e5b541784701FD8d65F11fc0598FBC6332;\n', '\n', '    address constant crvIB = 0x5282a4eF67D9C33135340fB3289cc1711c13638C;\n', '    address constant crvIBPool = 0x2dded6Da1BF5DBdF597C45fcFaa3194e53EcfeAF;\n', '\n', '    address constant crvBUSD = 0x4807862AA8b2bF68830e4C8dc86D0e9A998e085a;\n', '    address constant crvFRAX = 0xd632f22692FaC7611d2AA1C0D552930D43CAEd3B;\n', '    address constant crvALUSD = 0x43b4FdFD4Ff969587185cDB6f0BD875c5Fc83f8c;\n', '    address constant crvLUSD = 0xEd279fDD11cA84bEef15AF5D39BB4d4bEE23F0cA;\n', '\n', '    address constant crvMetaZapper = 0xA79828DF1850E8a3A3064576f380D90aECDD3359;\n', '\n', '    // **** Constructor ****\n', '\n', '    constructor(address _bmi) {\n', '        BMI = _bmi;\n', '    }\n', '\n', '    function recoverERC20(address _token) public onlyOwner {\n', '        IERC20(_token).safeTransfer(msg.sender, IERC20(_token).balanceOf(address(this)));\n', '    }\n', '\n', '    function recoverERC20s(address[] memory _tokens) public onlyOwner {\n', '        for (uint256 i = 0; i < _tokens.length; i++) {\n', '            IERC20(_tokens[i]).safeTransfer(msg.sender, IERC20(_tokens[i]).balanceOf(address(this)));\n', '        }\n', '    }\n', '\n', '    // **** View only functions **** //\n', '\n', '    // Estimates USDC equilavent for yearn crv and crv pools\n', '    function calcUSDCEquilavent(address _from, uint256 _amount) public view returns (uint256) {\n', '        if (_isYearnCRV(_from)) {\n', '            _amount = _amount.mul(IYearn(_from).pricePerShare()).div(1e18);\n', '            _from = IYearn(_from).token();\n', '        }\n', '\n', '        if (_from == crvY || _from == crvSUSD || _from == crvThree || _from == crvYBUSD) {\n', '            address zap = crvYZap;\n', '\n', '            if (_from == crvSUSD) {\n', '                zap = crvSUSDZap;\n', '            } else if (_from == crvThree) {\n', '                zap = crvThreePool;\n', '            } else if (_from == crvYBUSD) {\n', '                zap = crvYBUSDZap;\n', '            }\n', '\n', '            return ICurveZapSimple(zap).calc_withdraw_one_coin(_amount, 1);\n', '        } else if (_from == crvUSDN || _from == crvUSDP || _from == crvDUSD || _from == crvMUSD || _from == crvUST) {\n', '            address zap = crvUSDNZap;\n', '\n', '            if (_from == crvUSDP) {\n', '                zap = crvUSDPZap;\n', '            } else if (_from == crvDUSD) {\n', '                zap = crvDUSDZap;\n', '            } else if (_from == crvMUSD) {\n', '                zap = crvMUSDZap;\n', '            } else if (_from == crvUST) {\n', '                zap = crvUSTZap;\n', '            }\n', '\n', '            return ICurveZapSimple(zap).calc_withdraw_one_coin(_amount, 2);\n', '        } else if (_from == crvIB) {\n', '            return ICurveZapSimple(crvIBPool).calc_withdraw_one_coin(_amount, 1, true);\n', '        } else {\n', '            // Meta pools, USDC is 2nd index\n', '            return ICurveZapSimple(crvMetaZapper).calc_withdraw_one_coin(_from, _amount, 2);\n', '        }\n', '    }\n', '\n', '    function getUnderlyingAmount(address _derivative, uint256 _amount) public view returns (address, uint256) {\n', '        if (_isAave(_derivative)) {\n', '            return (IATokenV2(_derivative).UNDERLYING_ASSET_ADDRESS(), _amount);\n', '        }\n', '\n', '        if (_isCompound(_derivative)) {\n', '            uint256 rate = ICToken(_derivative).exchangeRateStored();\n', '            address underlying = ICToken(_derivative).underlying();\n', '            uint256 underlyingDecimals = ERC20(underlying).decimals();\n', '            uint256 mantissa = 18 + underlyingDecimals - 8;\n', '            uint256 oneCTokenInUnderlying = rate.mul(1e18).div(10**mantissa);\n', '            return (underlying, _amount.mul(oneCTokenInUnderlying).div(1e8));\n', '        }\n', '\n', '        // YearnCRV just or CRV return USDC\n', '        if (_isCRV(_derivative) || _isYearnCRV(_derivative)) {\n', '            return (USDC, calcUSDCEquilavent(_derivative, _amount));\n', '        }\n', '\n', '        if (_isYearn(_derivative)) {\n', '            _amount = _amount.mul(IYearn(_derivative).pricePerShare()).div(1e18);\n', '\n', '            if (_derivative == yDAI) {\n', '                return (DAI, _amount);\n', '            }\n', '\n', '            if (_derivative == yUSDC) {\n', '                return (USDC, _amount);\n', '            }\n', '\n', '            if (_derivative == yUSDT) {\n', '                return (USDT, _amount);\n', '            }\n', '\n', '            if (_derivative == yTUSD) {\n', '                return (TUSD, _amount);\n', '            }\n', '\n', '            if (_derivative == ySUSD) {\n', '                return (SUSD, _amount);\n', '            }\n', '        }\n', '\n', '        return (_derivative, _amount);\n', '    }\n', '\n', '    // **** Stateful functions ****\n', '\n', '    function zapToBMI(\n', '        address _from,\n', '        uint256 _amount,\n', '        address _fromUnderlying,\n', '        uint256 _fromUnderlyingAmount,\n', '        uint256 _minBMIRecv,\n', '        address[] memory _bmiConstituents,\n', '        uint256[] memory _bmiConstituentsWeightings,\n', '        address _aggregator,\n', '        bytes memory _aggregatorData,\n', '        bool refundDust\n', '    ) public returns (uint256) {\n', '        uint256 sum = 0;\n', '        for (uint256 i = 0; i < _bmiConstituentsWeightings.length; i++) {\n', '            sum = sum.add(_bmiConstituentsWeightings[i]);\n', '        }\n', '\n', '        // Sum should be between 0.999 and 1.000\n', '        assert(sum <= 1e18);\n', '        assert(sum >= 999e15);\n', '\n', '        // Transfer to contract\n', '        IERC20(_from).safeTransferFrom(msg.sender, address(this), _amount);\n', '\n', '        // Primitive\n', '        if (_isBare(_from)) {\n', '            _primitiveToBMI(_from, _amount, _bmiConstituents, _bmiConstituentsWeightings, _aggregator, _aggregatorData);\n', '        }\n', '        // Yearn (primitive)\n', '        else if (_isYearn(_from)) {\n', '            IYearn(_from).withdraw();\n', '            _primitiveToBMI(\n', '                _fromUnderlying,\n', '                _fromUnderlyingAmount,\n', '                _bmiConstituents,\n', '                _bmiConstituentsWeightings,\n', '                _aggregator,\n', '                _aggregatorData\n', '            );\n', '        }\n', '        // Yearn (primitive)\n', '        else if (_isYearnCRV(_from)) {\n', '            IYearn(_from).withdraw();\n', '            address crvToken = IYearn(_from).token();\n', '            _crvToPrimitive(crvToken, IERC20(crvToken).balanceOf(address(this)));\n', '            _primitiveToBMI(\n', '                USDC,\n', '                IERC20(USDC).balanceOf(address(this)),\n', '                _bmiConstituents,\n', '                _bmiConstituentsWeightings,\n', '                address(0),\n', '                ""\n', '            );\n', '        }\n', '        // Compound\n', '        else if (_isCompound(_from)) {\n', '            require(ICToken(_from).redeem(_amount) == 0, "!ctoken-redeem");\n', '            _primitiveToBMI(\n', '                _fromUnderlying,\n', '                _fromUnderlyingAmount,\n', '                _bmiConstituents,\n', '                _bmiConstituentsWeightings,\n', '                _aggregator,\n', '                _aggregatorData\n', '            );\n', '        }\n', '        // Aave\n', '        else if (_isAave(_from)) {\n', '            IERC20(_from).safeApprove(AAVE_LENDING_POOL_V2, 0);\n', '            IERC20(_from).safeApprove(AAVE_LENDING_POOL_V2, _amount);\n', '            ILendingPoolV2(AAVE_LENDING_POOL_V2).withdraw(_fromUnderlying, type(uint256).max, address(this));\n', '\n', '            _primitiveToBMI(\n', '                _fromUnderlying,\n', '                _fromUnderlyingAmount,\n', '                _bmiConstituents,\n', '                _bmiConstituentsWeightings,\n', '                _aggregator,\n', '                _aggregatorData\n', '            );\n', '        }\n', '        // Curve\n', '        else {\n', '            _crvToPrimitive(_from, _amount);\n', '            _primitiveToBMI(\n', '                USDC,\n', '                IERC20(USDC).balanceOf(address(this)),\n', '                _bmiConstituents,\n', '                _bmiConstituentsWeightings,\n', '                address(0),\n', '                ""\n', '            );\n', '        }\n', '\n', '        // Checks\n', '        uint256 _bmiBal = IERC20(BMI).balanceOf(address(this));\n', '        require(_bmiBal >= _minBMIRecv, "!min-mint");\n', '        IERC20(BMI).safeTransfer(msg.sender, _bmiBal);\n', '\n', '        // Convert back dust to USDC and refund remaining USDC to usd\n', '        if (refundDust) {\n', '            for (uint256 i = 0; i < _bmiConstituents.length; i++) {\n', '                _fromBMIConstituentToUSDC(_bmiConstituents[i], IERC20(_bmiConstituents[i]).balanceOf(address(this)));\n', '            }\n', '            IERC20(USDC).safeTransfer(msg.sender, IERC20(USDC).balanceOf(address(this)));\n', '        }\n', '\n', '        return _bmiBal;\n', '    }\n', '\n', '    // **** Internal helpers ****\n', '\n', '    function _crvToPrimitive(address _from, uint256 _amount) internal {\n', '        // Remove via zap to USDC\n', '        if (_from == crvY || _from == crvSUSD || _from == crvYBUSD) {\n', '            address zap = crvYZap;\n', '\n', '            if (_from == crvSUSD) {\n', '                zap = crvSUSDZap;\n', '            } else if (_from == crvYBUSD) {\n', '                zap = crvYBUSDZap;\n', '            }\n', '\n', '            IERC20(_from).safeApprove(zap, 0);\n', '            IERC20(_from).safeApprove(zap, _amount);\n', '            ICurveZapSimple(zap).remove_liquidity_one_coin(_amount, 1, 0, false);\n', '        } else if (_from == crvUSDP || _from == crvUSDN || _from == crvDUSD || _from == crvMUSD || _from == crvUST) {\n', '            address zap = crvUSDNZap;\n', '\n', '            if (_from == crvUSDP) {\n', '                zap = crvUSDPZap;\n', '            } else if (_from == crvDUSD) {\n', '                zap = crvDUSDZap;\n', '            } else if (_from == crvMUSD) {\n', '                zap = crvMUSDZap;\n', '            } else if (_from == crvUST) {\n', '                zap = crvUSTZap;\n', '            }\n', '\n', '            IERC20(_from).safeApprove(zap, 0);\n', '            IERC20(_from).safeApprove(zap, _amount);\n', '            ICurveZapSimple(zap).remove_liquidity_one_coin(_amount, 2, 0);\n', '        } else if (_from == crvIB) {\n', '            IERC20(_from).safeApprove(crvIBPool, 0);\n', '            IERC20(_from).safeApprove(crvIBPool, _amount);\n', '            ICurveZapSimple(crvIBPool).remove_liquidity_one_coin(_amount, 1, 0, true);\n', '        } else if (_from == crvThree) {\n', '            address zap = crvThreePool;\n', '\n', '            IERC20(_from).safeApprove(zap, 0);\n', '            IERC20(_from).safeApprove(zap, _amount);\n', '            ICurveZapSimple(zap).remove_liquidity_one_coin(_amount, 1, 0);\n', '        } else {\n', '            // Meta pools, USDC is 2nd index\n', '            IERC20(_from).safeApprove(crvMetaZapper, 0);\n', '            IERC20(_from).safeApprove(crvMetaZapper, _amount);\n', '            ICurveZapSimple(crvMetaZapper).remove_liquidity_one_coin(_from, _amount, 2, 0, address(this));\n', '        }\n', '    }\n', '\n', '    function _primitiveToBMI(\n', '        address _token,\n', '        uint256 _amount,\n', '        address[] memory _bmiConstituents,\n', '        uint256[] memory _bmiConstituentsWeightings,\n', '        address _aggregator,\n', '        bytes memory _aggregatorData\n', '    ) internal {\n', '        // Offset, DAI = 0, USDC = 1, USDT = 2\n', '        uint256 offset = 0;\n', '\n', '        // Primitive to USDC (if not already USDC)\n', '        if (_token != DAI && _token != USDC && _token != USDT) {\n', '            IERC20(_token).safeApprove(_aggregator, 0);\n', '            IERC20(_token).safeApprove(_aggregator, _amount);\n', '\n', '            (bool success, ) = _aggregator.call(_aggregatorData);\n', '            require(success, "!swap");\n', '\n', '            // Always goes to USDC\n', '            // If we swapping\n', '            _token = USDC;\n', '        }\n', '\n', '        if (_token == USDC) {\n', '            offset = 1;\n', '        } else if (_token == USDT) {\n', '            offset = 2;\n', '        }\n', '\n', '        // Amount to mint\n', '        uint256 amountToMint;\n', '        uint256 bmiSupply = IERC20(BMI).totalSupply();\n', '\n', '        uint256 tokenBal = IERC20(_token).balanceOf(address(this));\n', '        uint256 tokenAmount;\n', '        for (uint256 i = 0; i < _bmiConstituents.length; i++) {\n', '            // Weighting of the token for BMI constituient\n', '            tokenAmount = tokenBal.mul(_bmiConstituentsWeightings[i]).div(1e18);\n', '            _toBMIConstituent(_token, _bmiConstituents[i], tokenAmount, offset);\n', '\n', '            // Get amount to Mint\n', '            amountToMint = _approveBMIAndGetMintableAmount(bmiSupply, _bmiConstituents[i], amountToMint);\n', '        }\n', '\n', '        // Mint BASK\n', '        IBasket(BMI).mint(amountToMint);\n', '    }\n', '\n', '    function _approveBMIAndGetMintableAmount(\n', '        uint256 _bmiTotalSupply,\n', '        address _bmiConstituient,\n', '        uint256 _curMintAmount\n', '    ) internal returns (uint256) {\n', '        uint256 bal = IERC20(_bmiConstituient).balanceOf(address(this));\n', '        uint256 bmiBal = IERC20(_bmiConstituient).balanceOf(BMI);\n', '\n', '        IERC20(_bmiConstituient).safeApprove(BMI, 0);\n', '        IERC20(_bmiConstituient).safeApprove(BMI, bal);\n', '\n', '        // Calculate how much BMI we can mint at max\n', '        // Formula: min(e for e in bmiSupply * tokenWeHave[e] / tokenInBMI[e])\n', '        if (_curMintAmount == 0) {\n', '            return _bmiTotalSupply.mul(bal).div(bmiBal);\n', '        }\n', '\n', '        uint256 temp = _bmiTotalSupply.mul(bal).div(bmiBal);\n', '        if (temp < _curMintAmount) {\n', '            return temp;\n', '        }\n', '\n', '        return _curMintAmount;\n', '    }\n', '\n', '    function _toBMIConstituent(\n', '        address _fromToken,\n', '        address _toToken,\n', '        uint256 _amount,\n', '        uint256 _curveOffset\n', '    ) internal {\n', '        uint256 bal;\n', '        uint256[4] memory depositAmounts4 = [uint256(0), uint256(0), uint256(0), uint256(0)];\n', '\n', '        if (_toToken == ySUSD) {\n', '            IERC20(_fromToken).safeApprove(crvSUSDPool, 0);\n', '            IERC20(_fromToken).safeApprove(crvSUSDPool, _amount);\n', '\n', '            ICurvePool(crvSUSDPool).exchange(int128(_curveOffset), 3, _amount, 0);\n', '\n', '            bal = IERC20(SUSD).balanceOf(address(this));\n', '            IERC20(SUSD).safeApprove(ySUSD, 0);\n', '            IERC20(SUSD).safeApprove(ySUSD, bal);\n', '        }\n', '        // Gen 1 pools\n', '        else if (\n', '            _toToken == yCRV ||\n', '            _toToken == ycrvSUSD ||\n', '            _toToken == ycrvYBUSD ||\n', '            _toToken == ycrvUSDN ||\n', '            _toToken == ycrvUSDP ||\n', '            _toToken == ycrvDUSD ||\n', '            _toToken == ycrvMUSD ||\n', '            _toToken == ycrvUST\n', '        ) {\n', '            address crvToken = IYearn(_toToken).token();\n', '\n', '            address zap = crvYZap;\n', '            if (_toToken == ycrvSUSD) {\n', '                zap = crvSUSDZap;\n', '            } else if (_toToken == ycrvYBUSD) {\n', '                zap = crvYBUSDZap;\n', '            } else if (_toToken == ycrvUSDN) {\n', '                zap = crvUSDNZap;\n', '                _curveOffset += 1;\n', '            } else if (_toToken == ycrvUSDP) {\n', '                zap = crvUSDPZap;\n', '                _curveOffset += 1;\n', '            } else if (_toToken == ycrvDUSD) {\n', '                zap = crvDUSDZap;\n', '                _curveOffset += 1;\n', '            } else if (_toToken == ycrvMUSD) {\n', '                zap = crvMUSDZap;\n', '                _curveOffset += 1;\n', '            } else if (_toToken == ycrvUST) {\n', '                zap = crvUSTZap;\n', '                _curveOffset += 1;\n', '            }\n', '\n', '            depositAmounts4[_curveOffset] = _amount;\n', '            IERC20(_fromToken).safeApprove(zap, 0);\n', '            IERC20(_fromToken).safeApprove(zap, _amount);\n', '            ICurveZapSimple(zap).add_liquidity(depositAmounts4, 0);\n', '\n', '            bal = IERC20(crvToken).balanceOf(address(this));\n', '            IERC20(crvToken).safeApprove(_toToken, 0);\n', '            IERC20(crvToken).safeApprove(_toToken, bal);\n', '        } else if (_toToken == ycrvThree || _toToken == ycrvIB) {\n', '            address crvToken = IYearn(_toToken).token();\n', '\n', '            uint256[3] memory depositAmounts3 = [uint256(0), uint256(0), uint256(0)];\n', '            depositAmounts3[_curveOffset] = _amount;\n', '\n', '            address zap = crvThreePool;\n', '            if (_toToken == ycrvIB) {\n', '                zap = crvIBPool;\n', '            }\n', '\n', '            IERC20(_fromToken).safeApprove(zap, 0);\n', '            IERC20(_fromToken).safeApprove(zap, _amount);\n', '\n', '            if (_toToken == ycrvThree) {\n', '                ICurveZapSimple(zap).add_liquidity(depositAmounts3, 0);\n', '            } else {\n', '                ICurveZapSimple(zap).add_liquidity(depositAmounts3, 0, true);\n', '            }\n', '\n', '            bal = IERC20(crvToken).balanceOf(address(this));\n', '            IERC20(crvToken).safeApprove(_toToken, 0);\n', '            IERC20(crvToken).safeApprove(_toToken, bal);\n', '        }\n', '        // Meta pools\n', '        else if (_toToken == ycrvBUSD || _toToken == ycrvFRAX || _toToken == ycrvALUSD || _toToken == ycrvLUSD) {\n', '            // CRV Token = CRV Pool\n', '            address crvToken = IYearn(_toToken).token();\n', '\n', '            depositAmounts4[_curveOffset + 1] = _amount;\n', '            IERC20(_fromToken).safeApprove(crvMetaZapper, 0);\n', '            IERC20(_fromToken).safeApprove(crvMetaZapper, _amount);\n', '\n', '            ICurveZapSimple(crvMetaZapper).add_liquidity(crvToken, depositAmounts4, 0);\n', '\n', '            bal = IERC20(crvToken).balanceOf(address(this));\n', '            IERC20(crvToken).safeApprove(_toToken, 0);\n', '            IERC20(crvToken).safeApprove(_toToken, bal);\n', '        }\n', '\n', '        IYearn(_toToken).deposit();\n', '    }\n', '\n', '    function _fromBMIConstituentToUSDC(address _fromToken, uint256 _amount) internal {\n', '        if (_isYearnCRV(_fromToken)) {\n', '            _crvToPrimitive(IYearn(_fromToken).token(), IYearn(_fromToken).withdraw(_amount));\n', '        }\n', '    }\n', '\n', '    function _isBare(address _token) internal pure returns (bool) {\n', '        return (_token == DAI ||\n', '            _token == USDC ||\n', '            _token == USDT ||\n', '            _token == TUSD ||\n', '            _token == SUSD ||\n', '            _token == BUSD ||\n', '            _token == USDP ||\n', '            _token == FRAX ||\n', '            _token == ALUSD ||\n', '            _token == LUSD ||\n', '            _token == USDN);\n', '    }\n', '\n', '    function _isYearn(address _token) internal pure returns (bool) {\n', '        return (_token == yDAI || _token == yUSDC || _token == yUSDT || _token == yTUSD || _token == ySUSD);\n', '    }\n', '\n', '    function _isYearnCRV(address _token) internal pure returns (bool) {\n', '        return (_token == yCRV ||\n', '            _token == ycrvSUSD ||\n', '            _token == ycrvYBUSD ||\n', '            _token == ycrvBUSD ||\n', '            _token == ycrvUSDP ||\n', '            _token == ycrvFRAX ||\n', '            _token == ycrvALUSD ||\n', '            _token == ycrvLUSD ||\n', '            _token == ycrvUSDN ||\n', '            _token == ycrvThree ||\n', '            _token == ycrvIB ||\n', '            _token == ycrvMUSD ||\n', '            _token == ycrvUST ||\n', '            _token == ycrvDUSD);\n', '    }\n', '\n', '    function _isCRV(address _token) internal pure returns (bool) {\n', '        return (_token == crvY ||\n', '            _token == crvSUSD ||\n', '            _token == crvYBUSD ||\n', '            _token == crvBUSD ||\n', '            _token == crvUSDP ||\n', '            _token == crvFRAX ||\n', '            _token == crvALUSD ||\n', '            _token == crvLUSD ||\n', '            _token == crvThree ||\n', '            _token == crvUSDN ||\n', '            _token == crvDUSD ||\n', '            _token == crvMUSD ||\n', '            _token == crvUST ||\n', '            _token == crvIB);\n', '    }\n', '\n', '    function _isCompound(address _token) internal pure returns (bool) {\n', '        return (_token == cDAI || _token == cUSDC || _token == cUSDT || _token == cTUSD);\n', '    }\n', '\n', '    function _isAave(address _token) internal pure returns (bool) {\n', '        return (_token == aDAI || _token == aUSDC || _token == aUSDT || _token == aTUSD || _token == aSUSD);\n', '    }\n', '}']