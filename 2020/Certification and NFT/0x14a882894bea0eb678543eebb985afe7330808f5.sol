['/* Discussion:\n', ' * https://github.com/b-u-i-d-l/staking\n', ' */\n', '/* Description:\n', ' * buidl Liquidity Staking Mechanism V1\n', ' * \n', ' * The DFOhub Liquidity Staking Mechanism is designed to reward Uniswap V2 liquidity Providers (buidl-ETH and buidl-USDC exchanges) to lock long-therm liquidity.\n', ' * \n', " * The reward amount is fixed, and depends on the locking period selected. The reward system is independent from the buidl price. It's calculated based on how much buidl a holder uses to fill a liquidity pool, without any changes or dependency on the ETH or USDC values.\n", ' */\n', 'pragma solidity ^0.6.0;\n', '\n', 'contract StakingTransferFunctionality {\n', '\n', '    function onStart(address,address) public {\n', '    }\n', '\n', '    function onStop(address) public {\n', '    }\n', '\n', '    function stakingTransfer(address sender, uint256, uint256 value, address receiver) public {\n', '        IMVDProxy proxy = IMVDProxy(msg.sender);\n', '\n', '        require(IStateHolder(proxy.getStateHolderAddress()).getBool(_toStateHolderKey("authorizedToTransferForStaking", _toString(sender))) || IMVDFunctionalitiesManager(proxy.getMVDFunctionalitiesManagerAddress()).isAuthorizedFunctionality(sender), "Unauthorized action!");\n', '\n', '        proxy.transfer(receiver, value, proxy.getToken());\n', '    }\n', '\n', '    function _toStateHolderKey(string memory a, string memory b) private pure returns(string memory) {\n', '        return _toLowerCase(string(abi.encodePacked(a, "_", b)));\n', '    }\n', '\n', '    function _toString(address _addr) private pure returns(string memory) {\n', '        bytes32 value = bytes32(uint256(_addr));\n', '        bytes memory alphabet = "0123456789abcdef";\n', '\n', '        bytes memory str = new bytes(42);\n', "        str[0] = '0';\n", "        str[1] = 'x';\n", '        for (uint i = 0; i < 20; i++) {\n', '            str[2+i*2] = alphabet[uint(uint8(value[i + 12] >> 4))];\n', '            str[3+i*2] = alphabet[uint(uint8(value[i + 12] & 0x0f))];\n', '        }\n', '        return string(str);\n', '    }\n', '\n', '    function _toLowerCase(string memory str) private pure returns(string memory) {\n', '        bytes memory bStr = bytes(str);\n', '        for (uint i = 0; i < bStr.length; i++) {\n', '            bStr[i] = bStr[i] >= 0x41 && bStr[i] <= 0x5A ? bytes1(uint8(bStr[i]) + 0x20) : bStr[i];\n', '        }\n', '        return string(bStr);\n', '    }\n', '}\n', '\n', 'interface IMVDProxy {\n', '    function getToken() external view returns(address);\n', '    function getStateHolderAddress() external view returns(address);\n', '    function getMVDFunctionalitiesManagerAddress() external view returns(address);\n', '    function transfer(address receiver, uint256 value, address token) external;\n', '    function flushToWallet(address tokenAddress, bool is721, uint256 tokenId) external;\n', '}\n', '\n', 'interface IMVDFunctionalitiesManager {\n', '    function isAuthorizedFunctionality(address functionality) external view returns(bool);\n', '}\n', '\n', 'interface IStateHolder {\n', '    function getBool(string calldata varName) external view returns (bool);\n', '}\n', '\n', 'interface IERC20 {\n', '    function mint(uint256 amount) external;\n', '    function balanceOf(address account) external view returns (uint256);\n', '}']