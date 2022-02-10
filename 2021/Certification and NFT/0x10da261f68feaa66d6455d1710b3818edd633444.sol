['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-27\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT AND GPL-v3-or-later\n', 'pragma solidity 0.8.1;\n', '\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes calldata) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '\n', 'abstract contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the caller is the current owner.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return _msgSender() == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', 'contract CloneFactory {\n', '    function createClone(address target, bytes32 salt) internal returns (address result) {\n', '        bytes20 targetBytes = bytes20(target);\n', '        assembly {\n', '            let clone := mload(0x40)\n', '            mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)\n', '            mstore(add(clone, 0x14), targetBytes)\n', '            mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)\n', '            result := create2(0, clone, 0x37, salt)\n', '        }\n', '  }\n', '  \n', '  function computeCloneAddress(address target, bytes32 salt) internal view returns (address) {\n', '        bytes20 targetBytes = bytes20(target);\n', '        bytes32 bytecodeHash;\n', '        assembly {\n', '            let clone := mload(0x40)\n', '            mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)\n', '            mstore(add(clone, 0x14), targetBytes)\n', '            mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)\n', '            bytecodeHash := keccak256(clone, 0x37)\n', '        }\n', '        bytes32 _data = keccak256(\n', '            abi.encodePacked(bytes1(0xff), address(this), salt, bytecodeHash)\n', '        );\n', '        return address(bytes20(_data << 96));\n', '    }\n', '    \n', '    function isClone(address target, address query) internal view returns (bool result) {\n', '        bytes20 targetBytes = bytes20(target);\n', '        assembly {\n', '            let clone := mload(0x40)\n', '            mstore(clone, 0x363d3d373d3d3d363d7300000000000000000000000000000000000000000000)\n', '            mstore(add(clone, 0xa), targetBytes)\n', '            mstore(add(clone, 0x1e), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)\n', '            \n', '            let other := add(clone, 0x40)\n', '            extcodecopy(query, other, 0, 0x2d)\n', '            result := and(\n', '                eq(mload(clone), mload(other)),\n', '                eq(mload(add(clone, 0xd)), mload(add(other, 0xd)))\n', '            )\n', '        }\n', '    }\n', '}\n', '\n', '\n', 'library MerkleProof {\n', '    /**\n', '     * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree\n', '     * defined by `root`. For this, a `proof` must be provided, containing\n', '     * sibling hashes on the branch from the leaf to the root of the tree. Each\n', '     * pair of leaves and each pair of pre-images are assumed to be sorted.\n', '     */\n', '    function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {\n', '        bytes32 computedHash = leaf;\n', '\n', '        for (uint256 i = 0; i < proof.length; i++) {\n', '            bytes32 proofElement = proof[i];\n', '\n', '            if (computedHash <= proofElement) {\n', '                // Hash(current computed hash + current element of the proof)\n', '                computedHash = keccak256(abi.encodePacked(computedHash, proofElement));\n', '            } else {\n', '                // Hash(current element of the proof + current computed hash)\n', '                computedHash = keccak256(abi.encodePacked(proofElement, computedHash));\n', '            }\n', '        }\n', '\n', '        // Check if the computed hash (root) is equal to the provided root\n', '        return computedHash == root;\n', '    }\n', '}\n', '\n', '\n', 'interface IERC20 {\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function balanceOf(address account) external view returns (uint256);\n', '}\n', '\n', '\n', 'interface IERC721 {\n', '    function safeTransferFrom(address from, address to, uint256 tokenId) external;\n', '    function ownerOf(uint256 tokenId) external view returns (address owner);\n', '}\n', '\n', '\n', 'library Address {\n', '    /**\n', '     * @dev Returns true if `account` is a contract.\n', '     *\n', '     * [IMPORTANT]\n', '     * ====\n', '     * It is unsafe to assume that an address for which this function returns\n', '     * false is an externally-owned account (EOA) and not a contract.\n', '     *\n', '     * Among others, `isContract` will return false for the following\n', '     * types of addresses:\n', '     *\n', '     *  - an externally-owned account\n', '     *  - a contract in construction\n', '     *  - an address where a contract will be created\n', '     *  - an address where a contract lived, but was destroyed\n', '     * ====\n', '     */\n', '    function isContract(address account) internal view returns (bool) {\n', '        // This method relies on extcodesize, which returns 0 for contracts in\n', '        // construction, since the code is only stored at the end of the\n', '        // constructor execution.\n', '\n', '        uint256 size;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { size := extcodesize(account) }\n', '        return size > 0;\n', '    }\n', '}\n', '\n', '\n', 'library SafeERC20 {\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    /**\n', '     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement\n', '     * on the return value: the return value is optional (but if data is returned, it must not be false).\n', '     * @param token The token targeted by the call.\n', '     * @param data The call data (encoded using abi.encode or one of its variants).\n', '     */\n', '    function callOptionalReturn(IERC20 token, bytes memory data) private {\n', "        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since\n", "        // we're implementing it ourselves.\n", '\n', '        // A Solidity high level call has three parts:\n', '        //  1. The target address is checked to verify it contains contract code\n', '        //  2. The call itself is made, and success asserted\n', '        //  3. The return value is decoded, which in turn checks the size of the returned data.\n', '        // solhint-disable-next-line max-line-length\n', '        require(address(token).isContract(), "SafeERC20: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', '\n', 'interface IAstrodrop {\n', '    // Returns the address of the token distributed by this contract.\n', '    function token() external view returns (address);\n', '    // Returns the merkle root of the merkle tree containing account balances available to claim.\n', '    function merkleRoot() external view returns (bytes32);\n', '    // Returns true if the index has been marked claimed.\n', '    function isClaimed(uint256 index) external view returns (bool);\n', '    // Claim the given amount of the token to the given address. Reverts if the inputs are invalid.\n', '    function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external;\n', '\n', '    // This event is triggered whenever a call to #claim succeeds.\n', '    event Claimed(uint256 index, address account, uint256 amount);\n', '}\n', '\n', '\n', 'contract Astrodrop is IAstrodrop, Ownable {\n', '    using SafeERC20 for IERC20;\n', '\n', '    address public override token;\n', '    bytes32 public override merkleRoot;\n', '    bool public initialized;\n', '    uint256 public expireTimestamp;\n', '\n', '    // This is a packed array of booleans.\n', '    mapping(uint256 => uint256) public claimedBitMap;\n', '\n', '    function init(address owner_, address token_, bytes32 merkleRoot_, uint256 expireTimestamp_) external {\n', '        require(!initialized, "Astrodrop: Initialized");\n', '        initialized = true;\n', '\n', '        token = token_;\n', '        merkleRoot = merkleRoot_;\n', '        expireTimestamp = expireTimestamp_;\n', '        \n', '        _transferOwnership(owner_);\n', '    }\n', '\n', '    function isClaimed(uint256 index) public view override returns (bool) {\n', '        uint256 claimedWordIndex = index / 256;\n', '        uint256 claimedBitIndex = index % 256;\n', '        uint256 claimedWord = claimedBitMap[claimedWordIndex];\n', '        uint256 mask = (1 << claimedBitIndex);\n', '        return claimedWord & mask == mask;\n', '    }\n', '\n', '    function _setClaimed(uint256 index) private {\n', '        uint256 claimedWordIndex = index / 256;\n', '        uint256 claimedBitIndex = index % 256;\n', '        claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);\n', '    }\n', '\n', '    function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external override {\n', "        require(!isClaimed(index), 'MerkleDistributor: Drop already claimed.');\n", '\n', '        // Verify the merkle proof.\n', '        bytes32 node = keccak256(abi.encodePacked(index, account, amount));\n', "        require(MerkleProof.verify(merkleProof, merkleRoot, node), 'Astrodrop: Invalid proof');\n", '\n', '        // Mark it claimed and send the token.\n', '        _setClaimed(index);\n', '        IERC20(token).safeTransfer(account, amount);\n', '\n', '        emit Claimed(index, account, amount);\n', '    }\n', '\n', '    function sweep(address token_, address target) external onlyOwner {\n', '        require(block.timestamp >= expireTimestamp || token_ != token, "Astrodrop: Not expired");\n', '        IERC20 tokenContract = IERC20(token_);\n', '        uint256 balance = tokenContract.balanceOf(address(this));\n', '        tokenContract.safeTransfer(target, balance);\n', '    }\n', '}\n', '\n', '\n', 'contract AstrodropERC721 is IAstrodrop, Ownable {\n', '    using SafeERC20 for IERC20;\n', '\n', '    address public override token;\n', '    bytes32 public override merkleRoot;\n', '    bool public initialized;\n', '    uint256 public expireTimestamp;\n', '\n', '    // This is a packed array of booleans.\n', '    mapping(uint256 => uint256) public claimedBitMap;\n', '\n', '    function init(address owner_, address token_, bytes32 merkleRoot_, uint256 expireTimestamp_) external {\n', '        require(!initialized, "Astrodrop: Initialized");\n', '        initialized = true;\n', '\n', '        token = token_;\n', '        merkleRoot = merkleRoot_;\n', '        expireTimestamp = expireTimestamp_;\n', '        \n', '        _transferOwnership(owner_);\n', '    }\n', '\n', '    function isClaimed(uint256 index) public view override returns (bool) {\n', '        uint256 claimedWordIndex = index / 256;\n', '        uint256 claimedBitIndex = index % 256;\n', '        uint256 claimedWord = claimedBitMap[claimedWordIndex];\n', '        uint256 mask = (1 << claimedBitIndex);\n', '        return claimedWord & mask == mask;\n', '    }\n', '\n', '    function _setClaimed(uint256 index) private {\n', '        uint256 claimedWordIndex = index / 256;\n', '        uint256 claimedBitIndex = index % 256;\n', '        claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);\n', '    }\n', '\n', '    function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external override {\n', "        require(!isClaimed(index), 'MerkleDistributor: Drop already claimed.');\n", '\n', '        // Verify the merkle proof.\n', '        bytes32 node = keccak256(abi.encodePacked(index, account, amount));\n', "        require(MerkleProof.verify(merkleProof, merkleRoot, node), 'Astrodrop: Invalid proof');\n", '\n', '        // Mark it claimed and send the token.\n', '        _setClaimed(index);\n', '        IERC721 tokenContract = IERC721(token);\n', '        tokenContract.safeTransferFrom(tokenContract.ownerOf(amount), account, amount);\n', '\n', '        emit Claimed(index, account, amount);\n', '    }\n', '\n', '    function sweep(address token_, address target) external onlyOwner {\n', '        require(block.timestamp >= expireTimestamp || token_ != token, "Astrodrop: Not expired");\n', '        IERC20 tokenContract = IERC20(token_);\n', '        uint256 balance = tokenContract.balanceOf(address(this));\n', '        tokenContract.safeTransfer(target, balance);\n', '    }\n', '}\n', '\n', '\n', 'contract AstrodropFactory is CloneFactory {\n', '    event CreateAstrodrop(address astrodrop, bytes32 ipfsHash);\n', '\n', '    function createAstrodrop(\n', '        address template,\n', '        address token,\n', '        bytes32 merkleRoot,\n', '        uint256 expireTimestamp,\n', '        bytes32 salt,\n', '        bytes32 ipfsHash\n', '    ) external returns (Astrodrop drop) {\n', '        drop = Astrodrop(createClone(template, salt));\n', '        drop.init(msg.sender, token, merkleRoot, expireTimestamp);\n', '        emit CreateAstrodrop(address(drop), ipfsHash);\n', '    }\n', '\n', '    function computeAstrodropAddress(\n', '        address template,\n', '        bytes32 salt\n', '    ) external view returns (address) {\n', '        return computeCloneAddress(template, salt);\n', '    }\n', '    \n', '    function isAstrodrop(address template, address query) external view returns (bool) {\n', '        return isClone(template, query);\n', '    }\n', '}']