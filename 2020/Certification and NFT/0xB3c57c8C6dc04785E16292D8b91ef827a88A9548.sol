['// Copyright (C) 2020 Easy Chain. <https://easychain.tech>\n', '//\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '//\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the\n', '// GNU General Public License for more details.\n', '//\n', '// You should have received a copy of the GNU General Public License\n', '// along with this program. If not, see <https://www.gnu.org/licenses/>.\n', '\n', 'pragma experimental ABIEncoderV2;\n', 'pragma solidity 0.6.5;\n', '\n', 'interface ERC20 {\n', '    function approve(address, uint256) external returns (bool);\n', '    function transfer(address, uint256) external returns (bool);\n', '    function transferFrom(address, address, uint256) external returns (bool);\n', '    function name() external view returns (string memory);\n', '    function symbol() external view returns (string memory);\n', '    function decimals() external view returns (uint8);\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address) external view returns (uint256);\n', '}\n', '\n', '\n', 'struct ProtocolBalance {\n', '    ProtocolMetadata metadata;\n', '    AdapterBalance[] adapterBalances;\n', '}\n', '\n', '\n', 'struct ProtocolMetadata {\n', '    string name;\n', '    string description;\n', '    string websiteURL;\n', '    string iconURL;\n', '    uint256 version;\n', '}\n', '\n', '\n', 'struct AdapterBalance {\n', '    AdapterMetadata metadata;\n', '    FullTokenBalance[] balances;\n', '}\n', '\n', '\n', 'struct AdapterMetadata {\n', '    address adapterAddress;\n', '    string adapterType; // "Asset", "Debt"\n', '}\n', '\n', '\n', '// token and its underlying tokens (if exist) balances\n', 'struct FullTokenBalance {\n', '    TokenBalance base;\n', '    TokenBalance[] underlying;\n', '}\n', '\n', '\n', 'struct TokenBalance {\n', '    TokenMetadata metadata;\n', '    uint256 amount;\n', '}\n', '\n', '\n', '// ERC20-style token metadata\n', '// 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE address is used for ETH\n', 'struct TokenMetadata {\n', '    address token;\n', '    string name;\n', '    string symbol;\n', '    uint8 decimals;\n', '}\n', '\n', '\n', 'struct Component {\n', '    address token;\n', '    string tokenType;  // "ERC20" by default\n', '    uint256 rate;  // price per full share (1e18)\n', '}\n', '\n', '\n', 'interface IOneSplit {\n', '\n', '    function getExpectedReturn(\n', '        ERC20 fromToken,\n', '        ERC20 destToken,\n', '        uint256 amount,\n', '        uint256 parts,\n', '        uint256 flags\n', '    )\n', '        external\n', '        view\n', '        returns(\n', '            uint256 returnAmount,\n', '            uint256[] memory distribution\n', '        );\n', '}\n', '\n', 'interface IAdapterRegistry {\n', '\n', '    function getFinalFullTokenBalance(\n', '        string calldata tokenType,\n', '        address token\n', '    )\n', '        external\n', '        view\n', '        returns (FullTokenBalance memory);\n', '\n', '    function getFullTokenBalance(\n', '        string calldata tokenType,\n', '        address token\n', '    )\n', '        external\n', '        view\n', '        returns (FullTokenBalance memory);\n', '}\n', '\n', 'struct AdaptedBalance {\n', '    address token;\n', '    int256 amount; // can be negative, thus int\n', '}\n', '\n', '/**\n', ' * @dev BerezkaPriceTracker contract.\n', ' * This adapter provides on chain price tracking using 1inch exchange api\n', ' * @author Vasin Denis <denis.vasin@easychain.tech>\n', ' */\n', 'contract BerezkaPriceTracker {\n', '\n', '    string BEREZKA = "Berezka DAO";\n', '\n', '    ERC20 immutable USDC = ERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);\n', '    ERC20 immutable DAI  = ERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);\n', '    ERC20 immutable USDT = ERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);\n', '\n', '    IOneSplit immutable iOneSplit = IOneSplit(0xC586BeF4a0992C495Cf22e1aeEE4E446CECDee0E);\n', '    IAdapterRegistry adapterRegistry;\n', '\n', '    constructor(address _registryAddress) public {\n', '        require(_registryAddress != address(0), "Regisry address should be set");\n', '\n', '        adapterRegistry = IAdapterRegistry(_registryAddress);\n', '    }\n', '\n', '    function getPrice(\n', '        address _token\n', '    ) \n', '        public\n', '        view \n', '        returns (int256) \n', '    {\n', '        AdaptedBalance[] memory nonEmptyBalances\n', '            = getNonEmptyTokenBalances(_token);\n', '        return _getTokenBalancePrice(nonEmptyBalances); \n', '    }\n', '\n', '\n', '    // Internal functions\n', '\n', '    function _getTokenBalancePrice(\n', '        AdaptedBalance[] memory _balances\n', '    )\n', '        internal\n', '        view\n', '        returns (int256) \n', '    {\n', '        int256 result = 0;\n', '        uint256 length = _balances.length;\n', '        for (uint256 i = 0; i < length; i++) {\n', '            result += getTokenPrice(_balances[i].amount, _balances[i].token);\n', '        }\n', '        return result;\n', '    }\n', '\n', '    function getNonEmptyTokenBalances(\n', '        address _token\n', '    ) \n', '        public\n', '        view \n', '        returns (AdaptedBalance[] memory) \n', '    {\n', '        FullTokenBalance memory fullTokenBalance\n', '            = adapterRegistry.getFinalFullTokenBalance(BEREZKA, _token);\n', '        TokenBalance[] memory tokenBalances = fullTokenBalance.underlying;\n', '        uint256 count = 0;\n', '        uint256 length = tokenBalances.length;\n', '        for (uint256 i = 0; i < length; i++) {\n', '            if (tokenBalances[i].amount > 0) {\n', '                count++;\n', '            }\n', '        }\n', '        AdaptedBalance[] memory result = new AdaptedBalance[](count);\n', '        uint256 index = 0;\n', '        for (uint256 i = 0; i < length; i++) {\n', '            if (tokenBalances[i].amount > 0) {\n', '                result[index] = AdaptedBalance(\n', '                    tokenBalances[i].metadata.token,\n', '                    int256(tokenBalances[i].amount * 1e18) / 1e18\n', '                );\n', '                index++;\n', '            }\n', '        }\n', '        return result;\n', '    }\n', '\n', '    function getTokenPrice(\n', '        int256 _amount,\n', '        address _token\n', '    )\n', '        public\n', '        view\n', '        returns (int256) \n', '    {\n', '        int8     sign      = _amount < 0 ? -1 : int8(1);\n', '        uint256  absAmount = _amount < 0 ? uint256(-_amount) : uint256(_amount); \n', '        ERC20    token     = ERC20(_token);\n', '        uint8    count     = 0;\n', '        \n', '        uint256 priceUSDC = _getExpectedReturn(token, USDC, absAmount);\n', '        if (priceUSDC > 0) {\n', '            count++;\n', '        }\n', '\n', '        uint256 priceUSDT = _getExpectedReturn(token, USDT, absAmount);\n', '        if (priceUSDT > 0) {\n', '            count++;\n', '        }\n', '\n', '        uint256 priceDAIUSDC = 0;\n', '        uint256 priceDAI = _getExpectedReturn(token, DAI, absAmount);\n', '        if (priceDAI > 0) {\n', '            priceDAIUSDC = _getExpectedReturn(DAI, USDC, priceDAI);\n', '            if (priceDAIUSDC > 0) {\n', '                count++;\n', '            }\n', '        }\n', '\n', '        if (count == 0) {\n', '            return 0;\n', '        } else {\n', '            return sign * int256(((priceUSDC + priceDAIUSDC + priceUSDT) / count));\n', '        }\n', '    }\n', '\n', '    function getExpectedReturn(\n', '        ERC20 _fromToken,\n', '        ERC20 _destToken,\n', '        uint256 _amount\n', '    )\n', '        public\n', '        view\n', '        returns (uint256) \n', '    {\n', '        return _getExpectedReturn(_fromToken, _destToken, _amount);    \n', '    }\n', '\n', '    function _getExpectedReturn(\n', '        ERC20 _fromToken,\n', '        ERC20 _destToken,\n', '        uint256 _amount\n', '    )\n', '        internal\n', '        view\n', '        returns (uint256)\n', '    {\n', '        try iOneSplit.getExpectedReturn(\n', '            _fromToken,\n', '            _destToken,\n', '            _amount,\n', '            1,\n', '            0\n', '        ) returns (uint256 returnAmount, uint256[] memory) {\n', '            return returnAmount;\n', '        } catch {\n', '            return 0;\n', '        }\n', '    }\n', '}']