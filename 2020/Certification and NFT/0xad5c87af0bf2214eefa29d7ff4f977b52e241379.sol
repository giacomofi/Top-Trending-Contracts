['// Copyright (C) 2020 Easy Chain. <https://easychain.tech>\n', '//\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '//\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the\n', '// GNU General Public License for more details.\n', '//\n', '// You should have received a copy of the GNU General Public License\n', '// along with this program. If not, see <https://www.gnu.org/licenses/>.\n', '\n', 'pragma solidity 0.6.5;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'import { EnumerableSet } from "./lib/EnumerableSet.sol";\n', 'import { Ownable } from "../../Ownable.sol";\n', '\n', 'interface AdapterRegistry {\n', '\n', '    function isValidTokenAdapter(\n', '        string calldata tokenAdapterName\n', '    ) \n', '        external \n', '        returns (bool);\n', '}\n', '\n', 'struct TypedToken {\n', '    string tokenType;\n', '    address token;\n', '}\n', '\n', '/**\n', ' * @dev BerezkaTokenAdapterGovernance contract.\n', ' * Main function of this contract is to maintains a Structure of BerezkaDAO\n', ' * @author Vasin Denis <denis.vasin@easychain.tech>\n', ' */\n', 'contract BerezkaTokenAdapterGovernance is Ownable() {\n', '\n', '    AdapterRegistry internal constant ADAPTER_REGISTRY = \n', '        AdapterRegistry(0x06FE76B2f432fdfEcAEf1a7d4f6C3d41B5861672);\n', '\n', '    using EnumerableSet for EnumerableSet.AddressSet;\n', '\n', '    /// @dev This is a set of plain assets (ERC20) used by DAO. \n', '    /// This list also include addresses of Uniswap/Balancer tokenized pools.\n', '    mapping (string => EnumerableSet.AddressSet) private tokens;\n', '\n', '    /// @dev This is a list of all token types that are managed by contract\n', '    /// New token type is added to this list upon first adding a token with given type\n', '    string[] public tokenTypes;\n', '\n', '    /// @dev This is a set of debt protocol adapters that return debt in ETH\n', '    EnumerableSet.AddressSet private ethProtocols;\n', '\n', '    /// @dev This is a set of debt protocol adapters that return debt for ERC20 tokens\n', '    EnumerableSet.AddressSet private protocols;\n', '\n', '    /// @dev This is a mapping from Berezka DAO product to corresponding Vault addresses\n', '    mapping(address => address[]) private productVaults;\n', '\n', '    constructor(address[] memory _protocols, address[] memory _ethProtocols) public {\n', '        _add(protocols, _protocols);\n', '        _add(ethProtocols, _ethProtocols);\n', '    }\n', '\n', '    // Modification functions (all only by owner)\n', '\n', '    function setProductVaults(address _product, address[] memory _vaults) public onlyOwner() {\n', '        require(_product != address(0), "_product is 0");\n', '        require(_vaults.length > 0, "_vaults.length should be > 0");\n', '\n', '        productVaults[_product] = _vaults;\n', '    }\n', '\n', '    function removeProduct(address _product) public onlyOwner() {\n', '        require(_product != address(0), "_product is 0");\n', '\n', '        delete productVaults[_product];\n', '    }\n', '\n', '    function addTokens(string memory _type, address[] memory _tokens) public onlyOwner() {\n', '        require(_tokens.length > 0, "Length should be > 0");\n', '        require(ADAPTER_REGISTRY.isValidTokenAdapter(_type), "Invalid token adapter name");\n', '\n', '        if (tokens[_type].length() == 0) {\n', '            tokenTypes.push(_type);\n', '        }\n', '        _add(tokens[_type], _tokens);\n', '    }\n', '\n', '    function addProtocols(address[] memory _protocols) public onlyOwner() {\n', '        require(_protocols.length > 0, "Length should be > 0");\n', '\n', '        _add(protocols, _protocols);\n', '    }\n', '\n', '    function addEthProtocols(address[] memory _ethProtocols) public onlyOwner() {\n', '        require(_ethProtocols.length > 0, "Length should be > 0");\n', '\n', '        _add(ethProtocols, _ethProtocols);\n', '    }\n', '\n', '    function removeTokens(string memory _type, address[] memory _tokens) public onlyOwner() {\n', '        require(_tokens.length > 0, "Length should be > 0");\n', '\n', '        _remove(tokens[_type], _tokens);\n', '    }\n', '\n', '    function removeProtocols(address[] memory _protocols) public onlyOwner() {\n', '        require(_protocols.length > 0, "Length should be > 0");\n', '\n', '        _remove(protocols, _protocols);\n', '    }\n', '\n', '    function removeEthProtocols(address[] memory _ethProtocols) public onlyOwner() {\n', '        require(_ethProtocols.length > 0, "Length should be > 0");\n', '\n', '        _remove(ethProtocols, _ethProtocols);\n', '    }\n', '\n', '    function setTokenTypes(string[] memory _tokenTypes) public onlyOwner() {\n', '        require(_tokenTypes.length > 0, "Length should be > 0");\n', '\n', '        tokenTypes = _tokenTypes;\n', '    }\n', '\n', '    // View functions\n', '\n', '    function listTokens() external view returns (TypedToken[] memory) {\n', '        uint256 tokenLength = tokenTypes.length;\n', '        uint256 resultLength = 0;\n', '        for (uint256 i = 0; i < tokenLength; i++) {\n', '            resultLength += tokens[tokenTypes[i]].length();\n', '        }\n', '        TypedToken[] memory result = new TypedToken[](resultLength);\n', '        uint256 resultIndex = 0;\n', '        for (uint256 i = 0; i < tokenLength; i++) {\n', '            string memory tokenType = tokenTypes[i];\n', '            address[] memory typedTokens = _list(tokens[tokenType]);\n', '            uint256 typedTokenLength = typedTokens.length;\n', '            for (uint256 j = 0; j < typedTokenLength; j++) {\n', '                result[resultIndex] = TypedToken(tokenType, typedTokens[j]);\n', '                resultIndex++;\n', '            }\n', '        }\n', '        return result;\n', '    }\n', '\n', '    function listTokens(string calldata _type) external view returns (address[] memory) {\n', '        return _list(tokens[_type]);\n', '    }\n', '\n', '    function listProtocols() external view returns (address[] memory) {\n', '        return _list(protocols);\n', '    }\n', '\n', '    function listEthProtocols() external view returns (address[] memory) {\n', '        return _list(ethProtocols);\n', '    }\n', '\n', '    function getVaults(address _token) external view returns (address[] memory) {\n', '        return productVaults[_token];\n', '    }\n', '\n', '    // Internal functions\n', '\n', '    function _add(EnumerableSet.AddressSet storage _set, address[] memory _addresses) internal {\n', '        for (uint i = 0; i < _addresses.length; i++) {\n', '            _set.add(_addresses[i]);\n', '        }\n', '    }\n', '\n', '    function _remove(EnumerableSet.AddressSet storage _set, address[] memory _addresses) internal {\n', '        for (uint i = 0; i < _addresses.length; i++) {\n', '            _set.remove(_addresses[i]);\n', '        }\n', '    }\n', '\n', '    function _list(EnumerableSet.AddressSet storage _set) internal view returns(address[] memory) {\n', '        address[] memory result = new address[](_set.length());\n', '        for (uint i = 0; i < _set.length(); i++) {\n', '            result[i] = _set.at(i);\n', '        }\n', '        return result;\n', '    }\n', '}\n']
['// Copyright (C) 2020 Zerion Inc. <https://zerion.io>\n', '//\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '//\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the\n', '// GNU General Public License for more details.\n', '//\n', '// You should have received a copy of the GNU General Public License\n', '// along with this program. If not, see <https://www.gnu.org/licenses/>.\n', '\n', 'pragma solidity 0.6.5;\n', 'pragma experimental ABIEncoderV2;\n', '\n', '\n', 'interface ERC20 {\n', '    function approve(address, uint256) external returns (bool);\n', '    function transfer(address, uint256) external returns (bool);\n', '    function transferFrom(address, address, uint256) external returns (bool);\n', '    function name() external view returns (string memory);\n', '    function symbol() external view returns (string memory);\n', '    function decimals() external view returns (uint8);\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address) external view returns (uint256);\n', '}\n']
['// Copyright (C) 2020 Zerion Inc. <https://zerion.io>\n', '//\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '//\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the\n', '// GNU General Public License for more details.\n', '//\n', '// You should have received a copy of the GNU General Public License\n', '// along with this program. If not, see <https://www.gnu.org/licenses/>.\n', '\n', 'pragma solidity 0.6.5;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'import { TokenMetadata, Component } from "../Structs.sol";\n', '\n', '\n', '/**\n', ' * @title Token adapter interface.\n', ' * @dev getMetadata() and getComponents() functions MUST be implemented.\n', ' * @author Igor Sobolev <sobolev@zerion.io>\n', ' */\n', 'interface TokenAdapter {\n', '\n', '    /**\n', '     * @dev MUST return TokenMetadata struct with ERC20-style token info.\n', '     * struct TokenMetadata {\n', '     *     address token;\n', '     *     string name;\n', '     *     string symbol;\n', '     *     uint8 decimals;\n', '     * }\n', '     */\n', '    function getMetadata(address token) external view returns (TokenMetadata memory);\n', '\n', '    /**\n', '     * @dev MUST return array of Component structs with underlying tokens rates for the given token.\n', '     * struct Component {\n', '     *     address token;    // Address of token contract\n', '     *     string tokenType; // Token type ("ERC20" by default)\n', '     *     uint256 rate;     // Price per share (1e18)\n', '     * }\n', '     */\n', '    function getComponents(address token) external view returns (Component[] memory);\n', '}\n']
['// Copyright (C) 2020 Zerion Inc. <https://zerion.io>\n', '//\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '//\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the\n', '// GNU General Public License for more details.\n', '//\n', '// You should have received a copy of the GNU General Public License\n', '// along with this program. If not, see <https://www.gnu.org/licenses/>.\n', '\n', 'pragma solidity 0.6.5;\n', 'pragma experimental ABIEncoderV2;\n', '\n', '\n', 'struct ProtocolBalance {\n', '    ProtocolMetadata metadata;\n', '    AdapterBalance[] adapterBalances;\n', '}\n', '\n', '\n', 'struct ProtocolMetadata {\n', '    string name;\n', '    string description;\n', '    string websiteURL;\n', '    string iconURL;\n', '    uint256 version;\n', '}\n', '\n', '\n', 'struct AdapterBalance {\n', '    AdapterMetadata metadata;\n', '    FullTokenBalance[] balances;\n', '}\n', '\n', '\n', 'struct AdapterMetadata {\n', '    address adapterAddress;\n', '    string adapterType; // "Asset", "Debt"\n', '}\n', '\n', '\n', '// token and its underlying tokens (if exist) balances\n', 'struct FullTokenBalance {\n', '    TokenBalance base;\n', '    TokenBalance[] underlying;\n', '}\n', '\n', '\n', 'struct TokenBalance {\n', '    TokenMetadata metadata;\n', '    uint256 amount;\n', '}\n', '\n', '\n', '// ERC20-style token metadata\n', '// 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE address is used for ETH\n', 'struct TokenMetadata {\n', '    address token;\n', '    string name;\n', '    string symbol;\n', '    uint8 decimals;\n', '}\n', '\n', '\n', 'struct Component {\n', '    address token;\n', '    string tokenType;  // "ERC20" by default\n', '    uint256 rate;  // price per full share (1e18)\n', '}\n']
['// Copyright (C) 2020 Zerion Inc. <https://zerion.io>\n', '//\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '//\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the\n', '// GNU General Public License for more details.\n', '//\n', '// You should have received a copy of the GNU General Public License\n', '// along with this program. If not, see <https://www.gnu.org/licenses/>.\n', '\n', 'pragma solidity 0.6.5;\n', 'pragma experimental ABIEncoderV2;\n', '\n', '\n', 'abstract contract Ownable {\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner, "O: onlyOwner function!");\n', '        _;\n', '    }\n', '\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @notice Initializes owner variable with msg.sender address.\n', '     */\n', '    constructor() internal {\n', '        owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), msg.sender);\n', '    }\n', '\n', '    /**\n', '     * @notice Transfers ownership to the desired address.\n', '     * The function is callable only by the owner.\n', '     */\n', '    function transferOwnership(address _owner) external onlyOwner {\n', '        require(_owner != address(0), "O: new owner is the zero address!");\n', '        emit OwnershipTransferred(owner, _owner);\n', '        owner = _owner;\n', '    }\n', '}\n']
['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity 0.6.5;\n', '\n', '/**\n', ' * @dev Library for managing\n', ' * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive\n', ' * types.\n', ' *\n', ' * Sets have the following properties:\n', ' *\n', ' * - Elements are added, removed, and checked for existence in constant time\n', ' * (O(1)).\n', ' * - Elements are enumerated in O(n). No guarantees are made on the ordering.\n', ' *\n', ' * ```\n', ' * contract Example {\n', ' *     // Add the library methods\n', ' *     using EnumerableSet for EnumerableSet.AddressSet;\n', ' *\n', ' *     // Declare a set state variable\n', ' *     EnumerableSet.AddressSet private mySet;\n', ' * }\n', ' * ```\n', ' *\n', ' * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`\n', ' * (`UintSet`) are supported.\n', ' */\n', 'library EnumerableSet {\n', '    // To implement this library for multiple types with as little code\n', '    // repetition as possible, we write it in terms of a generic Set type with\n', '    // bytes32 values.\n', '    // The Set implementation uses private functions, and user-facing\n', '    // implementations (such as AddressSet) are just wrappers around the\n', '    // underlying Set.\n', '    // This means that we can only create new EnumerableSets for types that fit\n', '    // in bytes32.\n', '\n', '    struct Set {\n', '        // Storage of set values\n', '        bytes32[] _values;\n', '\n', '        // Position of the value in the `values` array, plus 1 because index 0\n', '        // means a value is not in the set.\n', '        mapping (bytes32 => uint256) _indexes;\n', '    }\n', '\n', '    /**\n', '     * @dev Add a value to a set. O(1).\n', '     *\n', '     * Returns true if the value was added to the set, that is if it was not\n', '     * already present.\n', '     */\n', '    function _add(Set storage set, bytes32 value) private returns (bool) {\n', '        if (!_contains(set, value)) {\n', '            set._values.push(value);\n', '            // The value is stored at length-1, but we add 1 to all indexes\n', '            // and use 0 as a sentinel value\n', '            set._indexes[value] = set._values.length;\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Removes a value from a set. O(1).\n', '     *\n', '     * Returns true if the value was removed from the set, that is if it was\n', '     * present.\n', '     */\n', '    function _remove(Set storage set, bytes32 value) private returns (bool) {\n', "        // We read and store the value's index to prevent multiple reads from the same storage slot\n", '        uint256 valueIndex = set._indexes[value];\n', '\n', '        if (valueIndex != 0) { // Equivalent to contains(set, value)\n', '            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in\n', "            // the array, and then remove the last element (sometimes called as 'swap and pop').\n", '            // This modifies the order of the array, as noted in {at}.\n', '\n', '            uint256 toDeleteIndex = valueIndex - 1;\n', '            uint256 lastIndex = set._values.length - 1;\n', '\n', '            // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs\n', "            // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.\n", '\n', '            bytes32 lastvalue = set._values[lastIndex];\n', '\n', '            // Move the last value to the index where the value to delete is\n', '            set._values[toDeleteIndex] = lastvalue;\n', '            // Update the index for the moved value\n', '            set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based\n', '\n', '            // Delete the slot where the moved value was stored\n', '            set._values.pop();\n', '\n', '            // Delete the index for the deleted slot\n', '            delete set._indexes[value];\n', '\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the value is in the set. O(1).\n', '     */\n', '    function _contains(Set storage set, bytes32 value) private view returns (bool) {\n', '        return set._indexes[value] != 0;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the number of values on the set. O(1).\n', '     */\n', '    function _length(Set storage set) private view returns (uint256) {\n', '        return set._values.length;\n', '    }\n', '\n', '   /**\n', '    * @dev Returns the value stored at position `index` in the set. O(1).\n', '    *\n', '    * Note that there are no guarantees on the ordering of values inside the\n', '    * array, and it may change when more values are added or removed.\n', '    *\n', '    * Requirements:\n', '    *\n', '    * - `index` must be strictly less than {length}.\n', '    */\n', '    function _at(Set storage set, uint256 index) private view returns (bytes32) {\n', '        require(set._values.length > index, "EnumerableSet: index out of bounds");\n', '        return set._values[index];\n', '    }\n', '\n', '    // AddressSet\n', '\n', '    struct AddressSet {\n', '        Set _inner;\n', '    }\n', '\n', '    /**\n', '     * @dev Add a value to a set. O(1).\n', '     *\n', '     * Returns true if the value was added to the set, that is if it was not\n', '     * already present.\n', '     */\n', '    function add(AddressSet storage set, address value) internal returns (bool) {\n', '        return _add(set._inner, bytes32(uint256(value)));\n', '    }\n', '\n', '    /**\n', '     * @dev Removes a value from a set. O(1).\n', '     *\n', '     * Returns true if the value was removed from the set, that is if it was\n', '     * present.\n', '     */\n', '    function remove(AddressSet storage set, address value) internal returns (bool) {\n', '        return _remove(set._inner, bytes32(uint256(value)));\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the value is in the set. O(1).\n', '     */\n', '    function contains(AddressSet storage set, address value) internal view returns (bool) {\n', '        return _contains(set._inner, bytes32(uint256(value)));\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the number of values in the set. O(1).\n', '     */\n', '    function length(AddressSet storage set) internal view returns (uint256) {\n', '        return _length(set._inner);\n', '    }\n', '\n', '   /**\n', '    * @dev Returns the value stored at position `index` in the set. O(1).\n', '    *\n', '    * Note that there are no guarantees on the ordering of values inside the\n', '    * array, and it may change when more values are added or removed.\n', '    *\n', '    * Requirements:\n', '    *\n', '    * - `index` must be strictly less than {length}.\n', '    */\n', '    function at(AddressSet storage set, uint256 index) internal view returns (address) {\n', '        return address(uint256(_at(set._inner, index)));\n', '    }\n', '\n', '\n', '    // UintSet\n', '\n', '    struct UintSet {\n', '        Set _inner;\n', '    }\n', '\n', '    /**\n', '     * @dev Add a value to a set. O(1).\n', '     *\n', '     * Returns true if the value was added to the set, that is if it was not\n', '     * already present.\n', '     */\n', '    function add(UintSet storage set, uint256 value) internal returns (bool) {\n', '        return _add(set._inner, bytes32(value));\n', '    }\n', '\n', '    /**\n', '     * @dev Removes a value from a set. O(1).\n', '     *\n', '     * Returns true if the value was removed from the set, that is if it was\n', '     * present.\n', '     */\n', '    function remove(UintSet storage set, uint256 value) internal returns (bool) {\n', '        return _remove(set._inner, bytes32(value));\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the value is in the set. O(1).\n', '     */\n', '    function contains(UintSet storage set, uint256 value) internal view returns (bool) {\n', '        return _contains(set._inner, bytes32(value));\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the number of values on the set. O(1).\n', '     */\n', '    function length(UintSet storage set) internal view returns (uint256) {\n', '        return _length(set._inner);\n', '    }\n', '\n', '   /**\n', '    * @dev Returns the value stored at position `index` in the set. O(1).\n', '    *\n', '    * Note that there are no guarantees on the ordering of values inside the\n', '    * array, and it may change when more values are added or removed.\n', '    *\n', '    * Requirements:\n', '    *\n', '    * - `index` must be strictly less than {length}.\n', '    */\n', '    function at(UintSet storage set, uint256 index) internal view returns (uint256) {\n', '        return uint256(_at(set._inner, index));\n', '    }\n', '}']
['// Copyright (C) 2020 Zerion Inc. <https://zerion.io>\n', '//\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '//\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the\n', '// GNU General Public License for more details.\n', '//\n', '// You should have received a copy of the GNU General Public License\n', '// along with this program. If not, see <https://www.gnu.org/licenses/>.\n', '\n', 'pragma solidity 0.6.5;\n', 'pragma experimental ABIEncoderV2;\n', '\n', '\n', '/**\n', ' * @title Protocol adapter interface.\n', ' * @dev adapterType(), tokenType(), and getBalance() functions MUST be implemented.\n', ' * @author Igor Sobolev <sobolev@zerion.io>\n', ' */\n', 'interface ProtocolAdapter {\n', '\n', '    /**\n', '     * @dev MUST return "Asset" or "Debt".\n', '     * SHOULD be implemented by the public constant state variable.\n', '     */\n', '    function adapterType() external pure returns (string memory);\n', '\n', '    /**\n', '     * @dev MUST return token type (default is "ERC20").\n', '     * SHOULD be implemented by the public constant state variable.\n', '     */\n', '    function tokenType() external pure returns (string memory);\n', '\n', '    /**\n', '     * @dev MUST return amount of the given token locked on the protocol by the given account.\n', '     */\n', '    function getBalance(address token, address account) external view returns (uint256);\n', '}\n']
['// Copyright (C) 2020 Easy Chain. <https://easychain.tech>\n', '//\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '//\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the\n', '// GNU General Public License for more details.\n', '//\n', '// You should have received a copy of the GNU General Public License\n', '// along with this program. If not, see <https://www.gnu.org/licenses/>.\n', '\n', 'pragma solidity 0.6.5;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'import { ERC20 } from "../../ERC20.sol";\n', 'import { TokenMetadata, Component } from "../../Structs.sol";\n', 'import { TokenAdapter } from "../TokenAdapter.sol";\n', 'import { ProtocolAdapter } from "../ProtocolAdapter.sol";\n', 'import { TypedToken } from "./BerezkaTokenAdapterGovernance.sol";\n', '\n', '\n', 'interface IBerezkaTokenAdapterGovernance {\n', '    \n', '    function listTokens() external view returns (TypedToken[] memory);\n', '\n', '    function listProtocols() external view returns (address[] memory);\n', '\n', '    function listEthProtocols() external view returns (address[] memory);\n', '\n', '    function listProducts() external view returns (address[] memory);\n', '\n', '    function getVaults(address _token) external view returns (address[] memory);\n', '}\n', '\n', 'interface IBerezkaTokenAdapterAssetGovernance {\n', '    \n', '    function listAssets() external view returns (address[] memory);\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Token adapter for Berezka DAO.\n', ' * @dev Implementation of TokenAdapter interface.\n', ' * @author Vasin Denis <denis.vasin@easychain.tech>\n', ' */\n', 'contract BerezkaTokenAdapter is TokenAdapter {\n', '\n', '    address internal constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;\n', '\n', '    string internal constant ERC20_TOKEN = "ERC20";\n', '\n', '    IBerezkaTokenAdapterGovernance immutable private governance;\n', '    IBerezkaTokenAdapterAssetGovernance immutable private assetGovernance;\n', '\n', '    constructor(address _governance, address _assetGovernance) public {\n', '        governance = IBerezkaTokenAdapterGovernance(_governance);\n', '        assetGovernance = IBerezkaTokenAdapterAssetGovernance(_assetGovernance);   \n', '    }\n', '\n', '    /**\n', '     * @return TokenMetadata struct with ERC20-style token info.\n', '     * @dev Implementation of TokenAdapter interface function.\n', '     */\n', '    function getMetadata(address token) \n', '        external \n', '        view \n', '        override \n', '        returns (TokenMetadata memory) \n', '    {\n', '        return TokenMetadata({\n', '            token: token,\n', '            name: ERC20(token).name(),\n', '            symbol: ERC20(token).symbol(),\n', '            decimals: ERC20(token).decimals()\n', '        });\n', '    }\n', '\n', '    /**\n', '     * @return Array of Component structs with underlying tokens rates for the given token.\n', '     * @dev Implementation of TokenAdapter interface function.\n', '     */\n', '    function getComponents(address token)\n', '        external\n', '        view\n', '        override\n', '        returns (Component[] memory)\n', '    {\n', '        address[] memory vaults = governance.getVaults(token);\n', '        TypedToken[] memory assets = governance.listTokens();\n', '        address[] memory debtAdapters = governance.listProtocols();\n', '        address[] memory assetAdapters = assetGovernance.listAssets();\n', '        uint256 length = assets.length;\n', '        uint256 totalSupply = ERC20(token).totalSupply();\n', '\n', '        Component[] memory underlyingTokens = new Component[](1 + length);\n', '        \n', '        // Handle ERC20 assets + debt\n', '        for (uint256 i = 0; i < length; i++) {\n', '            Component memory tokenComponent =\n', '                _getTokenComponents(\n', '                    assets[i].token, \n', '                    assets[i].tokenType, \n', '                    vaults, \n', '                    debtAdapters, \n', '                    assetAdapters,\n', '                    totalSupply\n', '                );\n', '            underlyingTokens[i] = tokenComponent;\n', '        }\n', '\n', '        // Handle ETH\n', '        {\n', '            Component memory ethComponent = _getEthComponents(vaults, totalSupply);\n', '            underlyingTokens[length] = ethComponent;\n', '        }\n', '        \n', '        return underlyingTokens;\n', '    }\n', '\n', '    // Internal functions\n', '\n', '    function _getEthComponents(\n', '        address[] memory _vaults,\n', '        uint256 _totalSupply\n', '    )\n', '        internal\n', '        view\n', '        returns (Component memory)\n', '    {\n', '        address[] memory debtsInEth = governance.listEthProtocols();\n', '\n', '        uint256 ethBalance = 0;\n', '        uint256 ethDebt = 0;\n', '\n', '        // Compute negative amount for a given asset using all debt adapters\n', '        for (uint256 j = 0; j < _vaults.length; j++) {\n', '            address vault = _vaults[j];\n', '            ethBalance += vault.balance;\n', '            ethDebt += _computeDebt(debtsInEth, ETH, vault);\n', '        }\n', '\n', '        return Component({\n', '            token: ETH,\n', '            tokenType: ERC20_TOKEN,\n', '            rate: (ethBalance * 1e18 / _totalSupply) - (ethDebt * 1e18 / _totalSupply)\n', '        });\n', '    }\n', '\n', '    function _getTokenComponents(\n', '        address _asset,\n', '        string memory _type,\n', '        address[] memory _vaults,\n', '        address[] memory _debtAdapters,\n', '        address[] memory _assetAdapters,\n', '        uint256 _totalSupply\n', '    ) \n', '        internal\n', '        view\n', '        returns (Component memory)\n', '    {\n', '        uint256 componentBalance = 0;\n', '        uint256 componentAssetBalance = 0;\n', '        uint256 componentDebt = 0;\n', '\n', '        // Compute positive amount for a given asset\n', '        uint256 vaultsLength = _vaults.length;\n', '        for (uint256 j = 0; j < vaultsLength; j++) {\n', '            address vault = _vaults[j];\n', '            componentBalance += ERC20(_asset).balanceOf(vault);\n', '            componentAssetBalance += _computeAssetBalance(_assetAdapters, _asset, vault);\n', '            componentDebt += _computeDebt(_debtAdapters, _asset, vault);\n', '        }\n', '\n', '        // Asset amount\n', '        return(Component({\n', '            token: _asset,\n', '            tokenType: _type,\n', '            rate: (componentBalance * 1e18 / _totalSupply) + (componentAssetBalance * 1e18 / _totalSupply) - (componentDebt * 1e18 / _totalSupply)\n', '        }));\n', '    }\n', '\n', '    function _computeDebt(\n', '        address[] memory _debtAdapters,\n', '        address _asset,\n', '        address _vault\n', '    ) \n', '        internal\n', '        view\n', '        returns (uint256)\n', '    {\n', '        // Compute negative amount for a given asset using all debt adapters\n', '        uint256 componentDebt = 0;\n', '        uint256 debtsLength = _debtAdapters.length;\n', '        for (uint256 k = 0; k < debtsLength; k++) {\n', '            ProtocolAdapter debtAdapter = ProtocolAdapter(_debtAdapters[k]);\n', '            try debtAdapter.getBalance(_asset, _vault) returns (uint256 _amount) {\n', '                componentDebt += _amount;\n', '            } catch {} // solhint-disable-line no-empty-blocks\n', '        }\n', '        return componentDebt;\n', '    }\n', '\n', '    function _computeAssetBalance(\n', '        address[] memory _assetAdapters,\n', '        address _asset,\n', '        address _vault\n', '    ) \n', '        internal\n', '        view\n', '        returns (uint256)\n', '    {\n', '        // Compute positive asset amount for a given asset using all asset adapters\n', '        uint256 componentAssetBalance = 0;\n', '        uint256 assetsLength = _assetAdapters.length;\n', '        for (uint256 k = 0; k < assetsLength; k++) {\n', '            ProtocolAdapter assetAdapter = ProtocolAdapter(_assetAdapters[k]);\n', '            try assetAdapter.getBalance(_asset, _vault) returns (uint256 _amount) {\n', '                componentAssetBalance += _amount;\n', '            } catch {} // solhint-disable-line no-empty-blocks\n', '        }\n', '        return componentAssetBalance;\n', '    }\n', '}\n']