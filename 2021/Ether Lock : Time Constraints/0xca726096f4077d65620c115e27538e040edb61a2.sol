['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-16\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity >=0.7.0 <0.8.0;\n', '\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes calldata) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', 'abstract contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view virtual returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(owner() == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// In the first version, claimed block nonce / mixDigest IS NOT VERIFIED\n', '// This contract assumes that MEV block template producer completely TRUSTS pool operator that received the signed work order.\n', '// This contract !DOES NOT VERIFY! that block nonce / mixDigest is valid or that it was broadcasted without delay\n', "// In the next version we're planning to introduce trustless approach to verify submited block nonce on-chain(see smartpool) and verify delay in seconds for share submission(using oracles)\n", 'contract LogOfClaimedMEVBlocks is Ownable {\n', '    uint256 internal constant FLAG_BLOCK_NONCE_LIMIT = 0x10000000000000000;\n', '    mapping (address => uint) public timestampOfPossibleExit;\n', '    mapping (address => uint) public depositedEther;\n', '\n', '    mapping (address => address) public blockSubmissionsOperator;\n', '    mapping (bytes32 => uint) public claimedBlockNonce;\n', '    mapping (bytes32 => bytes32) public claimedBlockMixDigest;\n', '\n', '    event Deposit(address user, uint amount);\n', '    event Withdraw(address user, uint amount);\n', '    event BlockClaimed(bytes32 blockHeader, bytes32 seedHash, bytes32 target, uint blockNumber, uint blockPayment, address miningPoolAddress, address mevProducerAddress, uint blockNonce, bytes32 mixDigest);\n', '\n', '\n', '    // Add another mining pool to mining DAO which will receive signed work orders directly from mev producers\n', '    function whitelistMiningPool(address miningPoolAddress) onlyOwner external {\n', '        assert(msg.data.length == 36);\n', '        blockSubmissionsOperator[miningPoolAddress] = miningPoolAddress;\n', '    }\n', '\n', '    function setBlockSubmissionsOperator(address newBlockSubmissionsOperator) external {\n', '        assert(msg.data.length == 36);\n', '        // This mining pool was already whitelisted\n', '        require(blockSubmissionsOperator[msg.sender] != 0x0000000000000000000000000000000000000000);\n', '        blockSubmissionsOperator[msg.sender] = newBlockSubmissionsOperator;\n', '    }\n', '\n', '    function depositAndLock(uint depositAmount, uint depositDuration) public payable {\n', '        require(depositAmount == msg.value);\n', '        // Enforcing min and max lockup durations\n', '        require(depositDuration >= 24 * 60 * 60 && depositDuration < 365 * 24 * 60 * 60);\n', '        timestampOfPossibleExit[msg.sender] = block.timestamp + depositDuration;\n', '        if (msg.value > 0) {\n', '            depositedEther[msg.sender] += msg.value;\n', '        }\n', '        emit Deposit(msg.sender, msg.value);\n', '    }\n', '    fallback () external payable {\n', '        depositAndLock(msg.value, 24 * 60 * 60);\n', '    }\n', '\n', '\n', '    function withdrawEtherInternal(uint etherAmount) internal {\n', '        // User previously deposited into contract\n', '        require(depositedEther[msg.sender] > 0);\n', '        // Deposit lockup period is over\n', '        require(block.timestamp > timestampOfPossibleExit[msg.sender]);\n', '        if (depositedEther[msg.sender] < etherAmount)\n', '            etherAmount = depositedEther[msg.sender];\n', '        depositedEther[msg.sender] -= etherAmount;\n', '        msg.sender.transfer(etherAmount);\n', '        emit Withdraw(msg.sender, etherAmount);\n', '    }\n', '\n', '    function withdrawAll() external {\n', '        withdrawEtherInternal((uint)(-1));\n', '    }\n', '    function withdraw(uint etherAmount) external {\n', '        withdrawEtherInternal(etherAmount);\n', '    }\n', '\n', '\n', '    function submitClaim(\n', '        bytes32 blockHeader,\n', '        bytes32 seedHash,\n', '        bytes32 target,\n', '        uint blockNumber,\n', '        uint blockPayment,\n', '        address payable miningPoolAddress,\n', '        address mevProducerAddress,\n', '        uint8 v,\n', '        bytes32 r,\n', '        bytes32 s,\n', '        uint blockNonce,\n', '        bytes32 mixDigest\n', '    ) external {\n', '        require(msg.sender == blockSubmissionsOperator[miningPoolAddress]);\n', '        bytes32 hash = keccak256(abi.encodePacked(blockHeader, seedHash, target, blockNumber, blockPayment, miningPoolAddress));\n', '        if (claimedBlockNonce[hash] == 0 && blockNonce < FLAG_BLOCK_NONCE_LIMIT) {\n', '            if (ecrecover(keccak256(abi.encodePacked("\\x19Ethereum Signed Message:\\n32", hash)),v,r,s) == mevProducerAddress) {\n', '                require(depositedEther[mevProducerAddress] >= blockPayment);\n', '                claimedBlockNonce[hash] = FLAG_BLOCK_NONCE_LIMIT + blockNonce;\n', '                claimedBlockMixDigest[hash] = mixDigest;\n', '                depositedEther[mevProducerAddress] -= blockPayment;\n', '                miningPoolAddress.transfer(blockPayment);\n', '                emit BlockClaimed(blockHeader, seedHash, target, blockNumber, blockPayment, miningPoolAddress, mevProducerAddress, blockNonce, mixDigest);\n', '            }\n', '        }\n', '    }\n', '\n', '    function checkValidityOfGetWork(\n', '        bytes32 blockHeader,\n', '        bytes32 seedHash,\n', '        bytes32 target,\n', '        uint blockNumber,\n', '        uint blockPayment,\n', '        address miningPoolAddress,\n', '        address mevProducerAddress,\n', '        uint8 v,\n', '        bytes32 r,\n', '        bytes32 s\n', '    ) public view returns (bool isWorkSignatureCorrect, uint remainingDuration) {\n', '        bytes32 hash = keccak256(abi.encodePacked(blockHeader, seedHash, target, blockNumber, blockPayment, miningPoolAddress));\n', '        if (claimedBlockNonce[hash] == 0) {\n', '            if (ecrecover(keccak256(abi.encodePacked("\\x19Ethereum Signed Message:\\n32", hash)),v,r,s) == mevProducerAddress) {\n', '                isWorkSignatureCorrect = true;\n', '                if (depositedEther[mevProducerAddress] >= blockPayment && timestampOfPossibleExit[mevProducerAddress] >  block.timestamp) {\n', '                    remainingDuration = timestampOfPossibleExit[mevProducerAddress] - block.timestamp;\n', '                }\n', '            }\n', '        }\n', '    }\n', '}']