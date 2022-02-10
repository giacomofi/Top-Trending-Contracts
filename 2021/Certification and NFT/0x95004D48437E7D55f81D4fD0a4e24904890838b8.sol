['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-01\n', '*/\n', '\n', '// SPDX-License-Identifier: https://github.com/lendroidproject/protocol.2.0/blob/master/LICENSE.md\n', '\n', '\n', '// File: @openzeppelin/contracts/GSN/Context.sol\n', '\n', 'pragma solidity ^0.7.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/access/Ownable.sol\n', '\n', 'pragma solidity ^0.7.0;\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/utils/Address.sol\n', '\n', 'pragma solidity ^0.7.0;\n', '\n', '/**\n', ' * @dev Collection of functions related to the address type\n', ' */\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * [IMPORTANT]\n', '     * ====\n', '     * It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     *\n', '     * Among others, `isContract` will return false for the following\n', '     * types of addresses:\n', '     *\n', '     *  - an externally-owned account\n', '     *  - a contract in construction\n', '     *  - an address where a contract will be created\n', '     *  - an address where a contract lived, but was destroyed\n', '     * ====\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts\n', '        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned\n', "        // for accounts without code, i.e. `keccak256('')`\n", '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != accountHash && codehash != 0x0);\n', '    }\n', '\n', '    /**\n', "     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n", '     * `recipient`, forwarding all available gas and reverting on errors.\n', '     *\n', '     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n', '     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n', '     * imposed by `transfer`, making them unable to receive funds via\n', '     * `transfer`. {sendValue} removes this limitation.\n', '     *\n', '     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n', '     *\n', '     * IMPORTANT: because control is transferred to `recipient`, care must be\n', '     * taken to not create reentrancy vulnerabilities. Consider using\n', '     * {ReentrancyGuard} or the\n', '     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n', '     */\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '        (bool success, ) = recipient.call{ value: amount }("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '\n', '    /**\n', '     * @dev Performs a Solidity function call using a low level `call`. A\n', '     * plain`call` is an unsafe replacement for a function call: use this\n', '     * function instead.\n', '     *\n', '     * If `target` reverts with a revert reason, it is bubbled up by this\n', '     * function (like regular Solidity function calls).\n', '     *\n', '     * Returns the raw returned data. To convert to the expected return value,\n', '     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `target` must be a contract.\n', '     * - calling `target` with `data` must not revert.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n', '      return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with\n', '     * `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        return _functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n', '     * but also transferring `value` wei to `target`.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - the calling contract must have an ETH balance of at least `value`.\n', '     * - the called Solidity function must be `payable`.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but\n', '     * with `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\n', '        require(address(this).balance >= value, "Address: insufficient balance for call");\n', '        return _functionCallWithValue(target, data, value, errorMessage);\n', '    }\n', '\n', '    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            // Look for revert reason and bubble it up if present\n', '            if (returndata.length > 0) {\n', '                // The easiest way to bubble the revert reason is using memory via assembly\n', '\n', '                // solhint-disable-next-line no-inline-assembly\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/auctions/IRandomMinter.sol\n', '\n', 'pragma solidity 0.7.5;\n', '\n', '\n', '/**\n', ' * @dev Required interface of an AuctionTokenProbabilityDistribution compliant contract.\n', ' */\n', 'interface IRandomMinter {\n', '    function mintWithRandomness(uint256 randomResult, address to) external returns(\n', '        address newTokenAddress, uint256 newTokenId, uint256 feePercentage);\n', '\n', '    function transferOwnership(address newOwner) external;\n', '\n', '    function currentOwner() external view returns (address);\n', '}\n', '\n', '// File: contracts/mocks/artblocks/IGenArt721Core.sol\n', '\n', 'pragma solidity 0.7.5;\n', '\n', '\n', '/**\n', ' * @dev Required interface of an ERC721WhaleStreet compliant contract.\n', ' */\n', 'interface IGenArt721Core {\n', '\n', '    function mint(address _to, uint256 _projectId, address _by) external returns (uint256 _tokenId);\n', '\n', '    function projectIdToArtistAddress(uint256 _projectId) external view returns (address _by);\n', '\n', '}\n', '\n', '// File: contracts/mocks/artblocks/ArtBlocksKeyMinter.sol\n', '\n', 'pragma solidity 0.7.5;\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract ArtBlocksKeyMinter is IRandomMinter, Ownable {\n', '\n', '    using Address for address;\n', '\n', '    enum Rarity { REGULAR, UNIQUE, LEGENDARY }\n', '\n', '    mapping(Rarity => uint256) public artblocksProjectIds;\n', '\n', '    mapping(Rarity => uint256) public daoTreasuryFeePercentages;\n', '\n', '    IGenArt721Core public auctionToken;\n', '\n', '    // solhint-disable-next-line func-visibility\n', '    constructor(address auctionTokenAddress) {\n', '        require(auctionTokenAddress.isContract(), "{ArtBlocksKeyMinter} : invalid auctionTokenAddress");\n', '        artblocksProjectIds[Rarity.REGULAR] = 79;\n', '        artblocksProjectIds[Rarity.UNIQUE] = 80;\n', '        artblocksProjectIds[Rarity.LEGENDARY] = 81;\n', '        daoTreasuryFeePercentages[Rarity.REGULAR] = 50;\n', '        daoTreasuryFeePercentages[Rarity.UNIQUE] = 25;\n', '        daoTreasuryFeePercentages[Rarity.LEGENDARY] = 5;\n', '        auctionToken = IGenArt721Core(auctionTokenAddress);\n', '    }\n', '\n', '    function currentOwner() external view override returns (address) {\n', '        return owner();\n', '    }\n', '\n', '    function mintWithRandomness(uint256 randomResult, address to) public onlyOwner override returns(\n', '        address newTokenAddress, uint256 newTokenId, uint256 feePercentage) {\n', '        newTokenAddress = address(auctionToken);\n', '        require(newTokenAddress != address(0), "auctionToken address is zero");\n', '        require((randomResult > 0) && (randomResult <= 100), "Invalid randomResult");\n', '        uint256 projectId;\n', '        if (randomResult > 0 && randomResult <= 15) {\n', '            projectId = artblocksProjectIds[Rarity.LEGENDARY];\n', '            feePercentage = daoTreasuryFeePercentages[Rarity.LEGENDARY];\n', '        } else if (randomResult > 15 && randomResult <= 50) {\n', '            projectId = artblocksProjectIds[Rarity.UNIQUE];\n', '            feePercentage = daoTreasuryFeePercentages[Rarity.UNIQUE];\n', '        } else {\n', '            projectId = artblocksProjectIds[Rarity.REGULAR];\n', '            feePercentage = daoTreasuryFeePercentages[Rarity.REGULAR];\n', '        }\n', '        address artist = auctionToken.projectIdToArtistAddress(projectId);\n', '        newTokenId = auctionToken.mint(to, projectId, artist);\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public override(IRandomMinter, Ownable) onlyOwner {\n', '        require(newOwner != address(0), "{transferOwnership} : invalid new owner");\n', '        super.transferOwnership(newOwner);\n', '    }\n', '\n', '}']