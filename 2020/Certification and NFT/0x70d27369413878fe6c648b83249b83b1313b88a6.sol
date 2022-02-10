['// File: @openzeppelin/contracts/GSN/Context.sol\n', '\n', '\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/access/Ownable.sol\n', '\n', '\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: contracts/registries/IAddressRegistry.sol\n', '\n', '\n', '\n', 'pragma solidity >=0.4.21 <0.7.0;\n', '\n', 'interface IAddressRegistry {\n', '    function get(bytes32 _key) external view returns(address);\n', '    function set(bytes32 _key, address _value) external;\n', '}\n', '\n', '// File: contracts/registries/AddressRegistryParent.sol\n', '\n', '\n', 'pragma solidity >=0.4.21 <0.7.0;\n', '\n', '\n', '\n', 'contract AddressRegistryParent is Ownable, IAddressRegistry{\n', '    bytes32[] internal _keys;\n', '    mapping(bytes32 => address) internal _registry;\n', '\n', '    event AddressAdded(bytes32 _key, address _value);\n', '\n', '    function set(bytes32 _key, address _value) external override onlyOwner() {\n', '        _check(_key, _value);\n', '        emit AddressAdded(_key, _value);\n', '        _keys.push(_key);\n', '        _registry[_key] = _value;\n', '    }\n', '\n', '    function get(bytes32 _key) external override view returns(address) {\n', '        return _registry[_key];\n', '    }\n', '\n', '    function _check(bytes32 _key, address _value) internal virtual {\n', '        require(_value != address(0), "Nullable address");\n', '        require(_registry[_key] == address(0), "Existed key");\n', '    }\n', '}\n', '\n', '// File: contracts/oracleIterators/IOracleIterator.sol\n', '\n', '\n', '\n', 'pragma solidity >=0.4.21 <0.7.0;\n', '\n', 'interface IOracleIterator {\n', '    /// @notice Proof of oracle iterator contract\n', '    /// @dev Verifies that contract is a oracle iterator contract\n', '    /// @return true if contract is a oracle iterator contract\n', '    function isOracleIterator() external pure returns(bool);\n', '\n', '    /// @notice Symbol of the oracle iterator\n', '    /// @dev Should be resolved through OracleIteratorRegistry contract\n', '    /// @return oracle iterator symbol\n', '    function symbol() external view returns (string memory);\n', '\n', '    /// @notice Algorithm that, for the type of oracle used by the derivative,\n', '    //  finds the value closest to a given timestamp\n', '    /// @param _oracle iteratable oracle through\n', '    /// @param _timestamp a given timestamp\n', '    /// @param _roundHint specified round for a given timestamp\n', '    /// @return the value closest to a given timestamp\n', '    function getUnderlingValue(address _oracle, uint _timestamp, uint _roundHint) external view returns(int);\n', '}\n', '\n', '// File: contracts/registries/OracleIteratorRegistry.sol\n', '\n', '// "SPDX-License-Identifier: GNU General Public License v3.0"\n', '\n', 'pragma solidity >=0.4.21 <0.7.0;\n', '\n', '\n', '\n', 'contract OracleIteratorRegistry is AddressRegistryParent {\n', '    function _check(bytes32 _key, address _value) internal virtual override{\n', '        super._check(_key, _value);\n', '\n', '        require(_key == keccak256(abi.encodePacked(IOracleIterator(_value).symbol())), "Incorrect hash");\n', '\n', '        require(IOracleIterator(_value).isOracleIterator(), "Should be oracle iterator");\n', '    }\n', '}']