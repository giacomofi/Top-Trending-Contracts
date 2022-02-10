['pragma solidity ^0.4.21;\n', '\n', 'contract Tikr {\n', '\n', '    mapping (bytes32 => uint256) tokenValues;\n', '    address adminAddress;\n', '    address managerAddress;\n', '\n', '    constructor () public {\n', '        adminAddress = msg.sender;\n', '        managerAddress = msg.sender;\n', '    }\n', '\n', '    modifier onlyAdmin() {\n', '        require(msg.sender == adminAddress);\n', '        _;\n', '    }\n', '\n', '    modifier onlyManager() {\n', '        require(msg.sender == managerAddress);\n', '        _;\n', '    }\n', '\n', '    function updateAdmin (address _adminAddress) public onlyAdmin {\n', '        adminAddress = _adminAddress;\n', '    }\n', '\n', '    function updateManager (address _managerAddress) public onlyAdmin {\n', '        managerAddress = _managerAddress;\n', '    }\n', '\n', '    function getPrice (bytes32 _ticker) public view returns (uint256) {\n', '        return tokenValues[_ticker];\n', '    }\n', '\n', '    function updatePrice (bytes32 _ticker, uint256 _price) public onlyManager {\n', '        tokenValues[_ticker] = _price;\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.21;\n', '\n', 'contract Tikr {\n', '\n', '    mapping (bytes32 => uint256) tokenValues;\n', '    address adminAddress;\n', '    address managerAddress;\n', '\n', '    constructor () public {\n', '        adminAddress = msg.sender;\n', '        managerAddress = msg.sender;\n', '    }\n', '\n', '    modifier onlyAdmin() {\n', '        require(msg.sender == adminAddress);\n', '        _;\n', '    }\n', '\n', '    modifier onlyManager() {\n', '        require(msg.sender == managerAddress);\n', '        _;\n', '    }\n', '\n', '    function updateAdmin (address _adminAddress) public onlyAdmin {\n', '        adminAddress = _adminAddress;\n', '    }\n', '\n', '    function updateManager (address _managerAddress) public onlyAdmin {\n', '        managerAddress = _managerAddress;\n', '    }\n', '\n', '    function getPrice (bytes32 _ticker) public view returns (uint256) {\n', '        return tokenValues[_ticker];\n', '    }\n', '\n', '    function updatePrice (bytes32 _ticker, uint256 _price) public onlyManager {\n', '        tokenValues[_ticker] = _price;\n', '    }\n', '\n', '}']