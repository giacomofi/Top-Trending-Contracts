['pragma solidity ^0.6.12;// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU General Public License for more details.\n', '\n', '// You should have received a copy of the GNU General Public License\n', '// along with this program.  If not, see <http://www.gnu.org/licenses/>.\n', '\n', '// SPDX-License-Identifier: GPL-3.0-only\n', '\n', '\n', '/**\n', ' * @title ITokenPriceRegistry\n', ' * @notice TokenPriceRegistry interface\n', ' */\n', 'interface ITokenPriceRegistry {\n', '    function getTokenPrice(address _token) external view returns (uint184 _price);\n', '    function isTokenTradable(address _token) external view returns (bool _isTradable);\n', '}\n', '\n', '\n', '/**\n', ' * @title Owned\n', ' * @notice Basic contract to define an owner.\n', ' * @author Julien Niset - <julien@argent.xyz>\n', ' */\n', 'contract Owned {\n', '\n', '    // The owner\n', '    address public owner;\n', '\n', '    event OwnerChanged(address indexed _newOwner);\n', '\n', '    /**\n', '     * @notice Throws if the sender is not the owner.\n', '     */\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner, "Must be owner");\n', '        _;\n', '    }\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @notice Lets the owner transfer ownership of the contract to a new owner.\n', '     * @param _newOwner The new owner.\n', '     */\n', '    function changeOwner(address _newOwner) external onlyOwner {\n', '        require(_newOwner != address(0), "Address must not be null");\n', '        owner = _newOwner;\n', '        emit OwnerChanged(_newOwner);\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Managed\n', ' * @notice Basic contract that defines a set of managers. Only the owner can add/remove managers.\n', ' * @author Julien Niset - <julien@argent.xyz>\n', ' */\n', 'contract Managed is Owned {\n', '\n', '    // The managers\n', '    mapping (address => bool) public managers;\n', '\n', '    /**\n', '     * @notice Throws if the sender is not a manager.\n', '     */\n', '    modifier onlyManager {\n', '        require(managers[msg.sender] == true, "M: Must be manager");\n', '        _;\n', '    }\n', '\n', '    event ManagerAdded(address indexed _manager);\n', '    event ManagerRevoked(address indexed _manager);\n', '\n', '    /**\n', '    * @notice Adds a manager.\n', '    * @param _manager The address of the manager.\n', '    */\n', '    function addManager(address _manager) external onlyOwner {\n', '        require(_manager != address(0), "M: Address must not be null");\n', '        if (managers[_manager] == false) {\n', '            managers[_manager] = true;\n', '            emit ManagerAdded(_manager);\n', '        }\n', '    }\n', '\n', '    /**\n', '    * @notice Revokes a manager.\n', '    * @param _manager The address of the manager.\n', '    */\n', '    function revokeManager(address _manager) external onlyOwner {\n', '        require(managers[_manager] == true, "M: Target must be an existing manager");\n', '        delete managers[_manager];\n', '        emit ManagerRevoked(_manager);\n', '    }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title TokenPriceRegistry\n', ' * @notice Contract storing the token prices.\n', ' * @notice Note that prices stored here = price per token * 10^(18-token decimals)\n', ' * The contract only defines basic setters and getters with no logic.\n', ' * Only managers of this contract can modify its state.\n', ' */\n', 'contract TokenPriceRegistry is ITokenPriceRegistry, Managed {\n', '    struct TokenInfo {\n', '        uint184 cachedPrice;\n', '        uint64 updatedAt;\n', '        bool isTradable;\n', '    }\n', '\n', '    // Price info per token\n', '    mapping(address => TokenInfo) public tokenInfo;\n', '    // The minimum period between two price updates\n', '    uint256 public minPriceUpdatePeriod;\n', '\n', '\n', '    // Getters\n', '\n', '    function getTokenPrice(address _token) external override view returns (uint184 _price) {\n', '        _price = tokenInfo[_token].cachedPrice;\n', '    }\n', '    function isTokenTradable(address _token) external override view returns (bool _isTradable) {\n', '        _isTradable = tokenInfo[_token].isTradable;\n', '    }\n', '    function getPriceForTokenList(address[] calldata _tokens) external view returns (uint184[] memory _prices) {\n', '        _prices = new uint184[](_tokens.length);\n', '        for (uint256 i = 0; i < _tokens.length; i++) {\n', '            _prices[i] = tokenInfo[_tokens[i]].cachedPrice;\n', '        }\n', '    }\n', '    function getTradableForTokenList(address[] calldata _tokens) external view returns (bool[] memory _tradable) {\n', '        _tradable = new bool[](_tokens.length);\n', '        for (uint256 i = 0; i < _tokens.length; i++) {\n', '            _tradable[i] = tokenInfo[_tokens[i]].isTradable;\n', '        }\n', '    }\n', '\n', '    // Setters\n', '    \n', '    function setMinPriceUpdatePeriod(uint256 _newPeriod) external onlyOwner {\n', '        minPriceUpdatePeriod = _newPeriod;\n', '    }\n', '    function setPriceForTokenList(address[] calldata _tokens, uint184[] calldata _prices) external onlyManager {\n', '        require(_tokens.length == _prices.length, "TPS: Array length mismatch");\n', '        for (uint i = 0; i < _tokens.length; i++) {\n', '            uint64 updatedAt = tokenInfo[_tokens[i]].updatedAt;\n', '            require(updatedAt == 0 || block.timestamp >= updatedAt + minPriceUpdatePeriod, "TPS: Price updated too early");\n', '            tokenInfo[_tokens[i]].cachedPrice = _prices[i];\n', '            tokenInfo[_tokens[i]].updatedAt = uint64(block.timestamp);\n', '        }\n', '    }\n', '    function setTradableForTokenList(address[] calldata _tokens, bool[] calldata _tradable) external {\n', '        require(_tokens.length == _tradable.length, "TPS: Array length mismatch");\n', '        for (uint256 i = 0; i < _tokens.length; i++) {\n', '            require(msg.sender == owner || (!_tradable[i] && managers[msg.sender]), "TPS: Unauthorised");\n', '            tokenInfo[_tokens[i]].isTradable = _tradable[i];\n', '        }\n', '    }\n', '}']