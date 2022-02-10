['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-30\n', '*/\n', '\n', '/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-08\n', '*/\n', '\n', '/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-18\n', '*/\n', '\n', '// SPDX-License-Identifier: UNLICENSED\n', 'pragma solidity ^0.6.7;\n', '\n', 'interface IERC1155 {\n', '    function safeTransferFrom(address _from, address _to, uint256 _id, uint256 value, bytes calldata _data) external;\n', '    function balanceOf(address _owner, uint256 _id) external view returns(uint256);\n', '}\n', '\n', 'interface IERC20 {\n', '    function balanceOf(address _who) external returns (uint256);\n', '}\n', '\n', 'library Math {\n', '    function add(uint a, uint b) internal pure returns (uint c) {require((c = a + b) >= b, "BoringMath: Add Overflow");}\n', '    function sub(uint a, uint b) internal pure returns (uint c) {require((c = a - b) <= a, "BoringMath: Underflow");}\n', '    function mul(uint a, uint b) internal pure returns (uint c) {require(a == 0 || (c = a * b)/b == a, "BoringMath: Mul Overflow");}\n', '}\n', '\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'contract Context {\n', '    // Empty internal constructor, to prevent people from mistakenly deploying\n', '    // an instance of this contract, which should be used via inheritance.\n', '    constructor () internal { }\n', '    // solhint-disable-previous-line no-empty-blocks\n', '\n', '    function _msgSender() internal view returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the caller is the current owner.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return _msgSender() == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract NftClaim is Ownable {\n', '    using Math for uint256;\n', '\n', '    address public seller;\n', '    IERC1155 public nft;\n', '    uint256[]  public ids;\n', '    mapping(address => bool) public claimants; // key is address, value is boolean where true means they can claim\n', '    \n', '    event Claim(address claimant);\n', '\n', '    constructor() public {\n', '        nft = IERC1155(0x13bAb10a88fc5F6c77b87878d71c9F1707D2688A);\n', '        seller = address(0x15884D7a5567725E0306A90262ee120aD8452d58);\n', '        ids = [71];\n', '    }\n', '    \n', '    function addClaimants(address[] memory _claimants) public onlyOwner {\n', '        for (uint i=0; i < _claimants.length; i++) { \n', '            claimants[_claimants[i]] = true;\n', '        }\n', '    }\n', '\n', '    function claim() public {\n', '        require(claimants[msg.sender], "cannot claim");\n', '        \n', '        for (uint i = 0; i < ids.length; i++) {\n', '            nft.safeTransferFrom(address(this), msg.sender, ids[i], 1, new bytes(0x0));\n', '        }\n', '        \n', '        claimants[msg.sender] = false;\n', '        emit Claim(msg.sender);\n', '    }\n', '    \n', '    function supply(uint256 id) public view returns(uint256) {\n', '        return nft.balanceOf(address(this), id);\n', '    }\n', '    \n', '    function pull() public onlyOwner {\n', '        for (uint i = 0; i < ids.length; i++) {\n', '            uint256 remainingSupply = supply(ids[i]);\n', '            nft.safeTransferFrom(address(this), seller, ids[i], remainingSupply, new bytes(0x0));\n', '        }\n', '    }\n', '    \n', '    function onERC1155Received(address, address, uint256, uint256, bytes calldata) external pure returns(bytes4) {\n', '        return bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"));\n', '    }\n', '\n', '}']