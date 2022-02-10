['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', 'import "../GSN/Context.sol";\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.12;\n', '\n', 'import "@openzeppelin/contracts/access/Ownable.sol";\n', 'import "./interface/IAddressResolver.sol";\n', '\n', '/**\n', '@notice Obtain different contract addresses based on different bytes32(name)\n', ' */\n', 'contract AddressResolver is Ownable, IAddressResolver {\n', '    mapping(bytes32 => address) public override key2address;\n', '    mapping(address => bytes32) public override address2key;\n', '\n', '    mapping(bytes32 =>mapping(bytes32 => address)) public override kk2addr;\n', '\n', '    function setAddress(bytes32 key, address addr) public override onlyOwner {\n', '        key2address[key] = addr;\n', '        address2key[addr] = key;\n', '    }\n', '\n', '    function setMultiAddress(bytes32[] memory keys, address[] memory addrs) external override onlyOwner {\n', '        require(keys.length == addrs.length, "AddressResolver::setMultiAddress:parameter number not match");\n', '        for (uint i=0; i < keys.length; i++) {\n', '            key2address[keys[i]] = addrs[i];\n', '            address2key[addrs[i]] = keys[i];\n', '        }\n', '    }\n', '\n', '    function requireAndKey2Address(bytes32 name, string calldata reason) external view override returns(address) {\n', '        address addr = key2address[name];\n', '        require(addr != address(0), reason);\n', '        return addr;\n', '    }\n', '\n', '    function setKkAddr(bytes32 k1, bytes32 k2, address addr) public override onlyOwner {\n', '        kk2addr[k1][k2] = addr;\n', '    } \n', '\n', '    function setMultiKKAddr(bytes32[] memory k1s, bytes32[] memory k2s, address[] memory addrs) external override onlyOwner {\n', '        require(k1s.length == k1s.length, "AddressResolver::setMultiKKAddr::parameter key number not match");\n', '        require(k1s.length == addrs.length, "AddressResolver::setMultiKKAddr::parameter key addrs number not match");\n', '        for (uint i=0; i < k1s.length; i++) {\n', '            kk2addr[k1s[i]][k2s[i]] = addrs[i];\n', '        }\n', '    }\n', '\n', '    function requireKKAddrs(bytes32 k1, bytes32 k2, string calldata reason) external view override returns(address) {\n', '        address addr = kk2addr[k1][k2];\n', '        require(addr != address(0), reason);\n', '        return addr;\n', '    }\n', '\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.12;\n', '\n', 'interface IAddressResolver {\n', '    \n', '    function key2address(bytes32 key) external view returns(address);\n', '    function address2key(address addr) external view returns(bytes32);\n', '    function requireAndKey2Address(bytes32 name, string calldata reason) external view returns(address);\n', '\n', '    function setAddress(bytes32 key, address addr) external;\n', '    function setMultiAddress(bytes32[] memory keys, address[] memory addrs) external;\n', '    \n', '    function setKkAddr(bytes32 k1, bytes32 k2, address addr) external;\n', '    function setMultiKKAddr(bytes32[] memory k1s, bytes32[] memory k2s, address[] memory addrs) external;\n', '\n', '    function kk2addr(bytes32 k1, bytes32 k2) external view returns(address);\n', '    function requireKKAddrs(bytes32 k1, bytes32 k2, string calldata reason) external view returns(address);\n', '}\n', '\n', '{\n', '  "evmVersion": "istanbul",\n', '  "libraries": {},\n', '  "metadata": {\n', '    "bytecodeHash": "ipfs",\n', '    "useLiteralContent": true\n', '  },\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 200\n', '  },\n', '  "remappings": [],\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  }\n', '}']