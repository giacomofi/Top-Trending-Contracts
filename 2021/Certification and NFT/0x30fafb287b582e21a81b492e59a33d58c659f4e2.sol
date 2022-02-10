['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.7.3;\n', '\n', 'import "./IO.sol";\n', 'import "./Storage.sol";\n', 'import "./Constants.sol";\n', '\n', 'import "./IATokenV1.sol";\n', 'import "./ICToken.sol";\n', 'import "./IComptroller.sol";\n', 'import "./ISushiBar.sol";\n', 'import "./ILendingPoolV1.sol";\n', 'import "./ICompoundLens.sol";\n', '\n', 'import "./IERC20.sol";\n', 'import "./SafeERC20.sol";\n', 'import "./SafeMath.sol";\n', '\n', 'contract YieldFarmingV0 is Storage, Constants, IO {\n', '    using SafeERC20 for IERC20;\n', '    using SafeMath for uint256;\n', '\n', '    // Events\n', '    event AssetReplaced(address indexed from, address indexed to);\n', '\n', '    // Aave\n', '    address public constant LENDING_POOL_V1 = 0x398eC7346DcD622eDc5ae82352F02bE94C62d119;\n', '    address public constant LENDING_POOL_CORE_V1 = 0x3dfd23A6c5E8BbcFc9581d2E864a68feb6a076d3;\n', '\n', '    // Compound\n', '    address public constant COMPTROLLER = 0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B;\n', '    address public constant LENS = 0xd513d22422a3062Bd342Ae374b4b9c20E0a9a074;\n', '\n', '    // Sushi\n', '    address public constant XSUSHI = 0x8798249c2E607446EfB7Ad49eC89dD1865Ff4272;\n', '\n', '    // CTokens\n', '    address public constant CUNI = 0x35A18000230DA775CAc24873d00Ff85BccdeD550;\n', '    address public constant CCOMP = 0x70e36f6BF80a52b3B46b3aF8e106CC0ed743E8e4;\n', '\n', '    // Underlying\n', '    address public constant UNI = 0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984;\n', '    address public constant COMP = 0xc00e94Cb662C3520282E6f5717214004A7f26888;\n', '    address public constant YFI = 0x0bc529c00C6401aEF6D220BE8C6Ea1667F6Ad93e;\n', '    address public constant SNX = 0xC011a73ee8576Fb46F5E1c5751cA3B9Fe0af2a6F;\n', '    address public constant MKR = 0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2;\n', '    address public constant REN = 0x408e41876cCCDC0F92210600ef50372656052a38;\n', '    address public constant KNC = 0xdd974D5C2e2928deA5F71b9825b8b646686BD200;\n', '    address public constant LRC = 0xBBbbCA6A901c926F240b89EacB641d8Aec7AEafD;\n', '    address public constant BAL = 0xba100000625a3754423978a60c9317c58a424e3D;\n', '    address public constant AAVE = 0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9;\n', '    address public constant MTA = 0xa3BeD4E1c75D00fa6f4E5E6922DB7261B5E9AcD2;\n', '    address public constant SUSHI = 0x6B3595068778DD592e39A122f4f5a5cF09C90fE2;\n', '\n', '    /// @notice Enters Compound market. *Must be called before toCToken*\n', '    /// @param  _markets  Compound markets to enter (underlying, not cTokens)\n', '    function enterMarkets(address[] memory _markets) external {\n', '        IComptroller(COMPTROLLER).enterMarkets(_markets);\n', '    }\n', '\n', '    /// @notice Supplies assets to the Compound market\n', '    /// @param  _token  Underlying token to supply to Compound\n', '    function toCToken(address _token) external {\n', '        _requireAssetData(_token);\n', '\n', '        // Only doing UNI or COMP for CTokens\n', '        require(_token == UNI || _token == COMP, "!valid-to-ctoken");\n', '\n', '        address _ctoken = _getTokenToCToken(_token);\n', '        uint256 balance = IERC20(_token).balanceOf(address(this));\n', '\n', '        require(balance > 0, "!token-bal");\n', '\n', '        IERC20(_token).safeApprove(_ctoken, balance);\n', '        require(ICToken(_ctoken).mint(balance) == 0, "!ctoken-mint");\n', '        _overrideAssetData(_token, _ctoken);\n', '    }\n', '\n', '    /// @notice Redeems assets from the Compound market\n', '    /// @param  _ctoken  CToken to redeem from Compound\n', '    function fromCToken(address _ctoken) external {\n', '        _requireAssetData(_ctoken);\n', '\n', '        // Only doing CUNI or CCOMP\n', '        require(_ctoken == CUNI || _ctoken == CCOMP, "!valid-from-ctoken");\n', '\n', '        address _token = ICToken(_ctoken).underlying();\n', '        uint256 balance = ICToken(_ctoken).balanceOf(address(this));\n', '\n', '        require(balance > 0, "!ctoken-bal");\n', '\n', '        require(ICToken(_ctoken).redeem(balance) == 0, "!ctoken-redeem");\n', '        _overrideAssetData(_ctoken, _token);\n', '    }\n', '\n', '    /// @notice Supplies assets to the Aave market\n', '    /// @param  _token  Underlying to supply to Aave\n', '    function toATokenV1(address _token) external {\n', '        _requireAssetData(_token);\n', '\n', '        require(_token != UNI && _token != COMP, "no-uni-or-comp");\n', '\n', '        uint256 balance = IERC20(_token).balanceOf(address(this));\n', '\n', '        require(balance > 0, "!token-bal");\n', '\n', '        IERC20(_token).safeApprove(LENDING_POOL_CORE_V1, balance);\n', '        ILendingPoolV1(LENDING_POOL_V1).deposit(_token, balance, 0);\n', '        (, , , , , , , , , , , address _atoken, ) = ILendingPoolV1(LENDING_POOL_V1).getReserveData(_token);\n', '\n', '        // Redirect Interest\n', '        address feeRecipient = _readSlotAddress(FEE_RECIPIENT);\n', '        require(feeRecipient != address(0), "!fee-recipient");\n', '\n', '        IATokenV1(_atoken).redirectInterestStream(feeRecipient);\n', '\n', '        _overrideAssetData(_token, _atoken);\n', '    }\n', '\n', '    /// @notice Redeems assets from the Aave market\n', '    /// @param  _atoken  AToken to redeem from Aave\n', '    function fromATokenV1(address _atoken) external {\n', '        _requireAssetData(_atoken);\n', '\n', '        uint256 balance = IATokenV1(_atoken).balanceOf(address(this));\n', '\n', '        require(balance > 0, "!atoken-bal");\n', '\n', '        IATokenV1(_atoken).redeem(balance);\n', '        address _token = IATokenV1(_atoken).underlyingAssetAddress();\n', '\n', '        _overrideAssetData(_atoken, _token);\n', '    }\n', '\n', '    /// @notice Claims accrued COMP tokens\n', '    function claimComp() external {\n', '        address feeRecipient = _readSlotAddress(FEE_RECIPIENT);\n', '        require(feeRecipient != address(0), "!fee-recipient");\n', '\n', '        uint256 _before = IERC20(COMP).balanceOf(address(this));\n', '\n', '        // Claims comp\n', '        address[] memory cTokens = new address[](2);\n', '        cTokens[0] = CUNI;\n', '        cTokens[1] = CCOMP;\n', '        IComptroller(COMPTROLLER).claimComp(address(this), cTokens);\n', '\n', '        // Calculates how much was given\n', '        uint256 _after = IERC20(COMP).balanceOf(address(this));\n', '        uint256 _amount = _after.sub(_before);\n', '\n', '        // Transfers to fee recipient\n', '        IERC20(COMP).safeTransfer(feeRecipient, _amount);\n', '    }\n', '\n', '    /// @notice Converts sushi to xsushi\n', '    function toXSushi() external {\n', '        _requireAssetData(SUSHI);\n', '\n', '        uint256 balance = IERC20(SUSHI).balanceOf(address(this));\n', '        require(balance > 0, "!sushi-bal");\n', '\n', '        IERC20(SUSHI).safeApprove(XSUSHI, balance);\n', '        ISushiBar(XSUSHI).enter(balance);\n', '\n', '        _overrideAssetData(SUSHI, XSUSHI);\n', '    }\n', '\n', '    /// @notice Goes from xsushi to sushi\n', '    function fromXSushi() external {\n', '        _requireAssetData(XSUSHI);\n', '\n', '        uint256 balance = IERC20(XSUSHI).balanceOf(address(this));\n', '        require(balance > 0, "!xsushi-bal");\n', '\n', '        ISushiBar(XSUSHI).leave(balance);\n', '        _overrideAssetData(XSUSHI, SUSHI);\n', '    }\n', '\n', '    // **** Pseudo-view functions (Use `callStatic`) ****\n', '\n', '    /// @dev Gets claimable comp for certain address\n', '    /// @param  _target Address to check for accrued comp\n', '    function getClaimableComp(address _target) public returns (uint256) {\n', '        (, , , uint256 accrued) = ICompoundLens(LENS).getCompBalanceMetadataExt(COMP, COMPTROLLER, _target);\n', '\n', '        return accrued;\n', '    }\n', '\n', '    // **** Internal ****\n', '\n', '    /// @dev Token to CToken mapping\n', '    /// @param  _token Token address\n', '    function _getTokenToCToken(address _token) internal pure returns (address) {\n', '        if (_token == UNI) {\n', '            return CUNI;\n', '        }\n', '        if (_token == COMP) {\n', '            return CCOMP;\n', '        }\n', '        revert("!supported-token-to-ctoken");\n', '    }\n', '\n', '    /// @dev Requires `_from` to be present in the `assets` variable in `Storage.sol`\n', '    /// @param  _from Token address\n', '    function _requireAssetData(address _from) internal view {\n', '        bool hasAsset = false;\n', '        for (uint256 i = 0; i < assets.length; i++) {\n', '            if (assets[i] == _from) {\n', '                hasAsset = true;\n', '            }\n', '        }\n', '        require(hasAsset, "!asset");\n', '    }\n', '\n', '    /// @dev Changes `_from` to `_to` in the `assets` variable in `Storage.sol`\n', '    /// @param  _from Token address to change from\n', '    /// @param  _to Token address to change to\n', '    function _overrideAssetData(address _from, address _to) internal {\n', '        // Override asset data\n', '        for (uint256 i = 0; i < assets.length; i++) {\n', '            if (assets[i] == _from) {\n', '                assets[i] = _to;\n', '\n', '                emit AssetReplaced(_from, _to);\n', '\n', '                return;\n', '            }\n', '        }\n', '    }\n', '}']