['pragma solidity ^0.6.0;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'interface CrTokenInterface {\n', '    function underlying() external view returns (address);\n', '}\n', '\n', 'interface ConnectorsInterface {\n', '    function chief(address) external view returns (bool);\n', '}\n', '\n', 'interface IndexInterface {\n', '    function master() external view returns (address);\n', '}\n', '\n', 'contract Helpers {\n', '    address public constant connectors = 0xD6A602C01a023B98Ecfb29Df02FBA380d3B21E0c;\n', '    address public constant instaIndex = 0x2971AdFa57b20E5a416aE5a708A8655A9c74f723;\n', '    uint public version = 1;\n', '\n', '    mapping (address => address) public crTokenMapping;\n', '\n', '    event LogAddcrTokenMapping(address crToken);\n', '    \n', '    modifier isChief {\n', '        require(\n', '            ConnectorsInterface(connectors).chief(msg.sender) ||\n', '            IndexInterface(instaIndex).master() == msg.sender, "not-Chief");\n', '        _;\n', '    }\n', '\n', '    function _addCrtknMapping(address crTkn) internal {\n', '        address cErc20 = crTkn;\n', '        address erc20 = CrTokenInterface(cErc20).underlying();\n', '        require(crTokenMapping[erc20] == address(0), "Token-Already-Added");\n', '        crTokenMapping[erc20] = cErc20;\n', '        emit LogAddcrTokenMapping(crTkn);\n', '    }\n', '\n', '    function addCrtknMapping(address[] memory crTkns) public isChief {\n', '        require(crTkns.length > 0, "No-CrToken-length");\n', '        for (uint i = 0; i < crTkns.length; i++) {\n', '            _addCrtknMapping(crTkns[i]);\n', '        }\n', '    }\n', '}\n', '\n', '\n', 'contract InstaCreamMapping is Helpers {\n', '    constructor(address[] memory crTkns) public {\n', '        address ethAddress = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;\n', '        address crEth = 0xD06527D5e56A3495252A528C4987003b712860eE;\n', '        crTokenMapping[ethAddress] = crEth;\n', '        for (uint i = 0; i < crTkns.length; i++) {\n', '            _addCrtknMapping(crTkns[i]);\n', '        }\n', '    }\n', '\n', '    string constant public name = "Cream-finance-v1.0";\n', '}']