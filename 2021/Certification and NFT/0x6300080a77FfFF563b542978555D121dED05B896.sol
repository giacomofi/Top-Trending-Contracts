['// SPDX-License-Identifier: UNLICENSED\n', 'pragma solidity ^0.7.0;\n', '\n', 'import "@openzeppelin/contracts/token/ERC20/IERC20.sol";\n', 'import "@openzeppelin/contracts/cryptography/MerkleProof.sol";\n', 'import "@openzeppelin/contracts/access/Ownable.sol";\n', 'import { InstaCompoundMerkleResolver } from "./compoundResolver.sol";\n', '\n', 'interface IndexInterface {\n', '    function master() external view returns (address);\n', '}\n', '\n', 'interface InstaListInterface {\n', '    function accountID(address) external view returns (uint64);\n', '}\n', '\n', 'interface InstaAccountInterface {\n', '    function version() external view returns (uint256);\n', '}\n', '\n', 'contract InstaCompoundMerkleDistributor is InstaCompoundMerkleResolver, Ownable {\n', '    event Claimed(\n', '        uint256 indexed index,\n', '        address indexed dsa,\n', '        address account,\n', '        uint256 claimedRewardAmount,\n', '        uint256 claimedNetworthsAmount\n', '    );\n', '\n', '    address public constant token = 0x6f40d4A6237C257fff2dB00FA0510DeEECd303eb;\n', '    address public constant instaIndex = 0x2971AdFa57b20E5a416aE5a708A8655A9c74f723;\n', '    InstaListInterface public constant instaList = \n', '        InstaListInterface(0x4c8a1BEb8a87765788946D6B19C6C6355194AbEb);\n', '    bytes32 public immutable merkleRoot;\n', '\n', '    // This is a packed array of booleans.\n', '    mapping(uint256 => uint256) private claimedBitMap;\n', '\n', '    constructor(bytes32 merkleRoot_, address _owner) public {\n', '        merkleRoot = merkleRoot_;\n', '        transferOwnership(_owner);\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if the sender not is Master Address from InstaIndex or owner\n', '    */\n', '    modifier isOwner {\n', '        require(_msgSender() == IndexInterface(instaIndex).master() || owner() == _msgSender(), "caller is not the owner or master");\n', '        _;\n', '    }\n', '\n', '    modifier isDSA {\n', '        require(instaList.accountID(msg.sender) != 0, "InstaCompoundMerkleDistributor:: not a DSA wallet");\n', '        require(InstaAccountInterface(msg.sender).version() == 2, "InstaCompoundMerkleDistributor:: not a DSAv2 wallet");\n', '        _;\n', '    }\n', '\n', '    function isClaimed(uint256 index) public view returns (bool) {\n', '        uint256 claimedWordIndex = index / 256;\n', '        uint256 claimedBitIndex = index % 256;\n', '        uint256 claimedWord = claimedBitMap[claimedWordIndex];\n', '        uint256 mask = (1 << claimedBitIndex);\n', '        return claimedWord & mask == mask;\n', '    }\n', '\n', '    function _setClaimed(uint256 index) private {\n', '        uint256 claimedWordIndex = index / 256;\n', '        uint256 claimedBitIndex = index % 256;\n', '        claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);\n', '    }\n', '\n', '    function claim(\n', '        uint256 index,\n', '        address account,\n', '        uint256 rewardAmount,\n', '        uint256 networthAmount,\n', '        bytes32[] calldata merkleProof,\n', '        address[] memory supplyCtokens,\n', '        address[] memory borrowCtokens,\n', '        uint256[] memory supplyAmounts,\n', '        uint256[] memory borrowAmounts\n', '    ) \n', '        external\n', '        isDSA\n', '    {\n', "        require(!isClaimed(index), 'InstaCompoundMerkleDistributor: Drop already claimed.');\n", '        require(supplyCtokens.length > 0, "InstaCompoundMerkleDistributor: Address length not vaild");\n', '        require(supplyCtokens.length == supplyAmounts.length, "InstaCompoundMerkleDistributor: supply addresses and amounts doesn\'t match");\n', '        require(borrowCtokens.length == borrowAmounts.length, "InstaCompoundMerkleDistributor: borrow addresses and amounts doesn\'t match");\n', '\n', '        // Verify the merkle proof.\n', '        bytes32 node = keccak256(abi.encodePacked(index, account, rewardAmount, networthAmount));\n', "        require(MerkleProof.verify(merkleProof, merkleRoot, node), 'InstaCompoundMerkleDistributor: Invalid proof.');\n", '\n', '        // Calculate claimable amount\n', '        (uint256 claimableRewardAmount, uint256 claimableNetworth) = getPosition(\n', '            networthAmount,\n', '            rewardAmount,\n', '            supplyCtokens,\n', '            borrowCtokens,\n', '            supplyAmounts,\n', '            borrowAmounts\n', '        );\n', '\n', '        require(claimableRewardAmount > 0 && claimableNetworth > 0, "InstaCompoundMerkleDistributor: claimable amounts not vaild");\n', "        require(rewardAmount >= claimableRewardAmount, 'InstaCompoundMerkleDistributor: claimableRewardAmount more then reward.');\n", '\n', '        // Mark it claimed and send the token.\n', '        _setClaimed(index);\n', "        require(IERC20(token).transfer(msg.sender, claimableRewardAmount), 'InstaCompoundMerkleDistributor: Transfer failed.');\n", '\n', '        emit Claimed(index, msg.sender, account, claimableRewardAmount, claimableNetworth);\n', '    }\n', '\n', '    function spell(address _target, bytes memory _data) public isOwner {\n', '        require(_target != address(0), "target-invalid");\n', '        assembly {\n', '        let succeeded := delegatecall(gas(), _target, add(_data, 0x20), mload(_data), 0, 0)\n', '        switch iszero(succeeded)\n', '            case 1 {\n', '                let size := returndatasize()\n', '                returndatacopy(0x00, 0x00, size)\n', '                revert(0x00, size)\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.7.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.7.0;\n', '\n', '/**\n', ' * @dev These functions deal with verification of Merkle trees (hash trees),\n', ' */\n', 'library MerkleProof {\n', '    /**\n', '     * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree\n', '     * defined by `root`. For this, a `proof` must be provided, containing\n', '     * sibling hashes on the branch from the leaf to the root of the tree. Each\n', '     * pair of leaves and each pair of pre-images are assumed to be sorted.\n', '     */\n', '    function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {\n', '        bytes32 computedHash = leaf;\n', '\n', '        for (uint256 i = 0; i < proof.length; i++) {\n', '            bytes32 proofElement = proof[i];\n', '\n', '            if (computedHash <= proofElement) {\n', '                // Hash(current computed hash + current element of the proof)\n', '                computedHash = keccak256(abi.encodePacked(computedHash, proofElement));\n', '            } else {\n', '                // Hash(current element of the proof + current computed hash)\n', '                computedHash = keccak256(abi.encodePacked(proofElement, computedHash));\n', '            }\n', '        }\n', '\n', '        // Check if the computed hash (root) is equal to the provided root\n', '        return computedHash == root;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.7.0;\n', '\n', 'import "../utils/Context.sol";\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'abstract contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view virtual returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(owner() == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', 'pragma solidity ^0.7.0;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'import { DSMath } from "../../../common/math.sol";\n', '\n', 'interface CTokenInterface {\n', '    function exchangeRateCurrent() external returns (uint256);\n', '    function borrowBalanceCurrent(address account) external returns (uint256);\n', '    function balanceOfUnderlying(address account) external returns (uint256);\n', '    function underlying() external view returns (address);\n', '    function balanceOf(address) external view returns (uint256);\n', '}\n', '\n', 'interface OracleCompInterface {\n', '    function getUnderlyingPrice(address) external view returns (uint256);\n', '}\n', '\n', 'interface ComptrollerLensInterface {\n', '    function markets(address)\n', '        external\n', '        view\n', '        returns (\n', '            bool,\n', '            uint256,\n', '            bool\n', '        );\n', '\n', '    function oracle() external view returns (address);\n', '}\n', '\n', 'contract Variables {\n', '    ComptrollerLensInterface public constant comptroller =\n', '        ComptrollerLensInterface(0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B);\n', '\n', '    address public constant cethAddr =\n', '        0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5;\n', '}\n', '\n', 'contract Resolver is Variables, DSMath {\n', '    function getPosition(\n', '        uint256 networthAmount,\n', '        uint256 rewardAmount,\n', '        address[] memory supplyCtokens,\n', '        address[] memory borrowCtokens,\n', '        uint256[] memory supplyCAmounts,\n', '        uint256[] memory borrowAmounts\n', '    )\n', '    public\n', '    returns (\n', '        uint256 claimableRewardAmount,\n', '        uint256 claimableNetworth\n', '    )\n', '    {\n', '        OracleCompInterface oracle = OracleCompInterface(comptroller.oracle());\n', '        uint256 totalBorrowInUsd = 0;\n', '        uint256 totalSupplyInUsd = 0;\n', '\n', '        for (uint256 i = 0; i < supplyCtokens.length; i++) {\n', '            require(supplyCAmounts[i] > 0, "InstaCompoundMerkleDistributor:: getPosition: supply camount not valid");\n', '            CTokenInterface cToken = CTokenInterface(address(supplyCtokens[i]));\n', '            uint256 priceInUSD = oracle.getUnderlyingPrice(address(cToken));\n', '            require(priceInUSD > 0, "InstaCompoundMerkleDistributor:: getPosition: priceInUSD not valid");\n', '            uint256 supplyAmount = wmul(supplyCAmounts[i], cToken.exchangeRateCurrent());\n', '            uint256 supplyInUsd = wmul(supplyAmount, priceInUSD);\n', '            totalSupplyInUsd = add(totalSupplyInUsd, supplyInUsd);\n', '        }\n', '\n', '        for (uint256 i = 0; i < borrowCtokens.length; i++) {\n', '            require(borrowAmounts[i] > 0, "InstaCompoundMerkleDistributor:: getPosition: borrow amount not valid");\n', '            CTokenInterface cToken = CTokenInterface(address(borrowCtokens[i]));\n', '            uint256 priceInUSD = oracle.getUnderlyingPrice(address(cToken));\n', '            require(priceInUSD > 0, "InstaCompoundMerkleDistributor:: getPosition: priceInUSD not valid");\n', '            uint256 borrowInUsd = wmul(borrowAmounts[i], priceInUSD);\n', '            totalBorrowInUsd = add(totalBorrowInUsd, borrowInUsd);\n', '        }\n', '\n', '        claimableNetworth = sub(totalSupplyInUsd, totalBorrowInUsd);\n', '        if (networthAmount > claimableNetworth) {\n', '            claimableRewardAmount = wdiv(claimableNetworth, networthAmount);\n', '            claimableRewardAmount = wmul(rewardAmount, claimableRewardAmount);\n', '        } else {\n', '            claimableRewardAmount = rewardAmount;\n', '        }\n', '    }\n', '}\n', 'contract InstaCompoundMerkleResolver is Resolver {\n', '    string public constant name = "Compound-Merkle-Resolver-v1.0";\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', 'pragma solidity ^0.7.0;\n', '\n', 'import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";\n', '\n', 'contract DSMath {\n', '  uint constant WAD = 10 ** 18;\n', '  uint constant RAY = 10 ** 27;\n', '\n', '  function add(uint x, uint y) internal pure returns (uint z) {\n', '    z = SafeMath.add(x, y);\n', '  }\n', '\n', '  function sub(uint x, uint y) internal virtual pure returns (uint z) {\n', '    z = SafeMath.sub(x, y);\n', '  }\n', '\n', '  function mul(uint x, uint y) internal pure returns (uint z) {\n', '    z = SafeMath.mul(x, y);\n', '  }\n', '\n', '  function div(uint x, uint y) internal pure returns (uint z) {\n', '    z = SafeMath.div(x, y);\n', '  }\n', '\n', '  function wmul(uint x, uint y) internal pure returns (uint z) {\n', '    z = SafeMath.add(SafeMath.mul(x, y), WAD / 2) / WAD;\n', '  }\n', '\n', '  function wdiv(uint x, uint y) internal pure returns (uint z) {\n', '    z = SafeMath.add(SafeMath.mul(x, WAD), y / 2) / y;\n', '  }\n', '\n', '  function rdiv(uint x, uint y) internal pure returns (uint z) {\n', '    z = SafeMath.add(SafeMath.mul(x, RAY), y / 2) / y;\n', '  }\n', '\n', '  function rmul(uint x, uint y) internal pure returns (uint z) {\n', '    z = SafeMath.add(SafeMath.mul(x, y), RAY / 2) / RAY;\n', '  }\n', '\n', '  function toInt(uint x) internal pure returns (int y) {\n', '    y = int(x);\n', '    require(y >= 0, "int-overflow");\n', '  }\n', '\n', '  function toRad(uint wad) internal pure returns (uint rad) {\n', '    rad = mul(wad, 10 ** 27);\n', '  }\n', '\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.7.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        uint256 c = a + b;\n', '        if (c < a) return (false, 0);\n', '        return (true, c);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the substraction of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b > a) return (false, 0);\n', '        return (true, a - b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) return (true, 0);\n', '        uint256 c = a * b;\n', '        if (c / a != b) return (false, 0);\n', '        return (true, c);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the division of two unsigned integers, with a division by zero flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b == 0) return (false, 0);\n', '        return (true, a / b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b == 0) return (false, 0);\n', '        return (true, a % b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) return 0;\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers, reverting on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "SafeMath: division by zero");\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * reverting when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "SafeMath: modulo by zero");\n', '        return a % b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {trySub}.\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers, reverting with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {tryDiv}.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * reverting with custom message when dividing by zero.\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {tryMod}.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": false,\n', '    "runs": 200\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  },\n', '  "libraries": {}\n', '}']