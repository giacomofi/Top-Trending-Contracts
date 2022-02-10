['pragma solidity 0.4.25;\n', '\n', 'library SafeMath {\n', '\n', '    /**\n', '     * @dev Multiplies two numbers, reverts on overflow.\n', '     */\n', '    function mul(uint256 _a, uint256 _b) internal pure returns(uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (_a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = _a * _b;\n', '        require(c / _a == _b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '     */\n', '    function div(uint256 _a, uint256 _b) internal pure returns(uint256) {\n', '        require(_b > 0); // Solidity only automatically asserts when dividing by 0\n', '        uint256 c = _a / _b;\n', "        // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '     */\n', '    function sub(uint256 _a, uint256 _b) internal pure returns(uint256) {\n', '        require(_b <= _a);\n', '        uint256 c = _a - _b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Adds two numbers, reverts on overflow.\n', '     */\n', '    function add(uint256 _a, uint256 _b) internal pure returns(uint256) {\n', '        uint256 c = _a + _b;\n', '        require(c >= _a);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '     * reverts when dividing by zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'library ExtendedMath {\n', '    function limitLessThan(uint a, uint b) internal pure returns(uint c) {\n', '        if (a > b) return b;\n', '        return a;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @dev Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', 'contract InterfaceContracts is Ownable {\n', '    InterfaceContracts public _internalMod;\n', '    \n', '    function setModifierContract (address _t) onlyOwner public {\n', '        _internalMod = InterfaceContracts(_t);\n', '    }\n', '\n', '    modifier onlyMiningContract() {\n', '      require(msg.sender == _internalMod._contract_miner(), "Wrong sender");\n', '          _;\n', '      }\n', '\n', '    modifier onlyTokenContract() {\n', '      require(msg.sender == _internalMod._contract_token(), "Wrong sender");\n', '      _;\n', '    }\n', '    \n', '    modifier onlyMasternodeContract() {\n', '      require(msg.sender == _internalMod._contract_masternode(), "Wrong sender");\n', '      _;\n', '    }\n', '    \n', '    modifier onlyVotingOrOwner() {\n', '      require(msg.sender == _internalMod._contract_voting() || msg.sender == owner, "Wrong sender");\n', '      _;\n', '    }\n', '    \n', '    modifier onlyVotingContract() {\n', '      require(msg.sender == _internalMod._contract_voting() || msg.sender == owner, "Wrong sender");\n', '      _;\n', '    }\n', '      \n', '    function _contract_voting () public view returns (address) {\n', '        return _internalMod._contract_voting();\n', '    }\n', '    \n', '    function _contract_masternode () public view returns (address) {\n', '        return _internalMod._contract_masternode();\n', '    }\n', '    \n', '    function _contract_token () public view returns (address) {\n', '        return _internalMod._contract_token();\n', '    }\n', '    \n', '    function _contract_miner () public view returns (address) {\n', '        return _internalMod._contract_miner();\n', '    }\n', '}\n', '\n', 'interface ICaelumMasternode {\n', '    function _externalArrangeFlow() external;\n', '    function rewardsProofOfWork() external returns (uint) ;\n', '    function rewardsMasternode() external returns (uint) ;\n', '    function masternodeIDcounter() external returns (uint) ;\n', '    function masternodeCandidate() external returns (uint) ;\n', '    function getUserFromID(uint) external view returns  (address) ;\n', '    function contractProgress() external view returns (uint, uint, uint, uint, uint, uint, uint, uint);\n', '}\n', '\n', 'interface ICaelumToken {\n', '    function rewardExternal(address, uint) external;\n', '}\n', '\n', 'interface EIP918Interface  {\n', '\n', '    /*\n', '     * Externally facing mint function that is called by miners to validate challenge digests, calculate reward,\n', '     * populate statistics, mutate epoch variables and adjust the solution difficulty as required. Once complete,\n', '     * a Mint event is emitted before returning a success indicator.\n', '     **/\n', '  \tfunction mint(uint256 nonce, bytes32 challenge_digest) external returns (bool success);\n', '\n', '\n', '\t/*\n', '     * Returns the challenge number\n', '     **/\n', '    function getChallengeNumber() external view returns (bytes32);\n', '\n', '    /*\n', '     * Returns the mining difficulty. The number of digits that the digest of the PoW solution requires which\n', '     * typically auto adjusts during reward generation.\n', '     **/\n', '    function getMiningDifficulty() external view returns (uint);\n', '\n', '    /*\n', '     * Returns the mining target\n', '     **/\n', '    function getMiningTarget() external view returns (uint);\n', '\n', '    /*\n', '     * Return the current reward amount. Depending on the algorithm, typically rewards are divided every reward era\n', '     * as tokens are mined to provide scarcity\n', '     **/\n', '    function getMiningReward() external view returns (uint);\n', '\n', '    /*\n', '     * Upon successful verification and reward the mint method dispatches a Mint Event indicating the reward address,\n', '     * the reward amount, the epoch count and newest challenge number.\n', '     **/\n', '    event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);\n', '\n', '}\n', '\n', 'contract AbstractERC918 is EIP918Interface {\n', '\n', '    // generate a new challenge number after a new reward is minted\n', '    bytes32 public challengeNumber;\n', '\n', '    // the current mining difficulty\n', '    uint public difficulty;\n', '\n', '    // cumulative counter of the total minted tokens\n', '    uint public tokensMinted;\n', '\n', '    // track read only minting statistics\n', '    struct Statistics {\n', '        address lastRewardTo;\n', '        uint lastRewardAmount;\n', '        uint lastRewardEthBlockNumber;\n', '        uint lastRewardTimestamp;\n', '    }\n', '\n', '    Statistics public statistics;\n', '\n', '    /*\n', '     * Externally facing mint function that is called by miners to validate challenge digests, calculate reward,\n', '     * populate statistics, mutate epoch variables and adjust the solution difficulty as required. Once complete,\n', '     * a Mint event is emitted before returning a success indicator.\n', '     **/\n', '    function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success);\n', '\n', '\n', '    /*\n', '     * Internal interface function _hash. Overide in implementation to define hashing algorithm and\n', '     * validation\n', '     **/\n', '    function _hash(uint256 nonce, bytes32 challenge_digest) internal returns (bytes32 digest);\n', '\n', '    /*\n', '     * Internal interface function _reward. Overide in implementation to calculate and return reward\n', '     * amount\n', '     **/\n', '    function _reward() internal returns (uint);\n', '\n', '    /*\n', '     * Internal interface function _newEpoch. Overide in implementation to define a cutpoint for mutating\n', '     * mining variables in preparation for the next epoch\n', '     **/\n', '    function _newEpoch(uint256 nonce) internal returns (uint);\n', '\n', '    /*\n', '     * Internal interface function _adjustDifficulty. Overide in implementation to adjust the difficulty\n', '     * of the mining as required\n', '     **/\n', '    function _adjustDifficulty() internal returns (uint);\n', '\n', '}\n', '\n', 'contract CaelumAbstractMiner is InterfaceContracts, AbstractERC918 {\n', '    /**\n', '     * CaelumMiner contract.\n', '     *\n', '     * We need to make sure the contract is 100% compatible when using the EIP918Interface.\n', '     * This contract is an abstract Caelum miner contract.\n', '     *\n', "     * Function 'mint', and '_reward' are overriden in the CaelumMiner contract.\n", "     * Function '_reward_masternode' is added and needs to be overriden in the CaelumMiner contract.\n", '     */\n', '\n', '    using SafeMath for uint;\n', '    using ExtendedMath for uint;\n', '\n', '    uint256 public totalSupply = 2100000000000000;\n', '\n', '    uint public latestDifficultyPeriodStarted;\n', '    uint public epochCount;\n', '    uint public baseMiningReward = 50;\n', '    uint public blocksPerReadjustment = 512;\n', '    uint public _MINIMUM_TARGET = 2 ** 16;\n', '    uint public _MAXIMUM_TARGET = 2 ** 234;\n', '    uint public rewardEra = 0;\n', '\n', '    uint public maxSupplyForEra;\n', '    uint public MAX_REWARD_ERA = 39;\n', '    uint public MINING_RATE_FACTOR = 60; //mint the token 60 times less often than ether\n', '\n', '    uint public MAX_ADJUSTMENT_PERCENT = 100;\n', '    uint public TARGET_DIVISOR = 2000;\n', '    uint public QUOTIENT_LIMIT = TARGET_DIVISOR.div(2);\n', '    mapping(bytes32 => bytes32) solutionForChallenge;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '\n', '    bytes32 public challengeNumber;\n', '    uint public difficulty;\n', '    uint public tokensMinted;\n', '\n', '    Statistics public statistics;\n', '\n', '    event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);\n', '    event RewardMasternode(address candidate, uint amount);\n', '\n', '    constructor() public {\n', '        tokensMinted = 0;\n', '        maxSupplyForEra = totalSupply.div(2);\n', '        difficulty = _MAXIMUM_TARGET;\n', '        latestDifficultyPeriodStarted = block.number;\n', '        _newEpoch(0);\n', '    }\n', '\n', '    function _newEpoch(uint256 nonce) internal returns(uint) {\n', '        if (tokensMinted.add(getMiningReward()) > maxSupplyForEra && rewardEra < MAX_REWARD_ERA) {\n', '            rewardEra = rewardEra + 1;\n', '        }\n', '        maxSupplyForEra = totalSupply - totalSupply.div(2 ** (rewardEra + 1));\n', '        epochCount = epochCount.add(1);\n', '        challengeNumber = blockhash(block.number - 1);\n', '        return (epochCount);\n', '    }\n', '\n', '    function mint(uint256 nonce, bytes32 challenge_digest) public returns(bool success);\n', '\n', '    function _hash(uint256 nonce, bytes32 challenge_digest) internal returns(bytes32 digest) {\n', '        digest = keccak256(challengeNumber, msg.sender, nonce);\n', '        if (digest != challenge_digest) revert();\n', '        if (uint256(digest) > difficulty) revert();\n', '        bytes32 solution = solutionForChallenge[challengeNumber];\n', '        solutionForChallenge[challengeNumber] = digest;\n', '        if (solution != 0x0) revert(); //prevent the same answer from awarding twice\n', '    }\n', '\n', '    function _reward() internal returns(uint);\n', '\n', '    function _reward_masternode() internal returns(uint);\n', '\n', '    function _adjustDifficulty() internal returns(uint) {\n', '        //every so often, readjust difficulty. Dont readjust when deploying\n', '        if (epochCount % blocksPerReadjustment != 0) {\n', '            return difficulty;\n', '        }\n', '\n', '        uint ethBlocksSinceLastDifficultyPeriod = block.number - latestDifficultyPeriodStarted;\n', '        //assume 360 ethereum blocks per hour\n', "        //we want miners to spend 10 minutes to mine each 'block', about 60 ethereum blocks = one 0xbitcoin epoch\n", '        uint epochsMined = blocksPerReadjustment;\n', '        uint targetEthBlocksPerDiffPeriod = epochsMined * MINING_RATE_FACTOR;\n', '        //if there were less eth blocks passed in time than expected\n', '        if (ethBlocksSinceLastDifficultyPeriod < targetEthBlocksPerDiffPeriod) {\n', '            uint excess_block_pct = (targetEthBlocksPerDiffPeriod.mul(MAX_ADJUSTMENT_PERCENT)).div(ethBlocksSinceLastDifficultyPeriod);\n', '            uint excess_block_pct_extra = excess_block_pct.sub(100).limitLessThan(QUOTIENT_LIMIT);\n', '            // If there were 5% more blocks mined than expected then this is 5.  If there were 100% more blocks mined than expected then this is 100.\n', '            //make it harder\n', '            difficulty = difficulty.sub(difficulty.div(TARGET_DIVISOR).mul(excess_block_pct_extra)); //by up to 50 %\n', '        } else {\n', '            uint shortage_block_pct = (ethBlocksSinceLastDifficultyPeriod.mul(MAX_ADJUSTMENT_PERCENT)).div(targetEthBlocksPerDiffPeriod);\n', '            uint shortage_block_pct_extra = shortage_block_pct.sub(100).limitLessThan(QUOTIENT_LIMIT); //always between 0 and 1000\n', '            //make it easier\n', '            difficulty = difficulty.add(difficulty.div(TARGET_DIVISOR).mul(shortage_block_pct_extra)); //by up to 50 %\n', '        }\n', '        latestDifficultyPeriodStarted = block.number;\n', '        if (difficulty < _MINIMUM_TARGET) //very difficult\n', '        {\n', '            difficulty = _MINIMUM_TARGET;\n', '        }\n', '        if (difficulty > _MAXIMUM_TARGET) //very easy\n', '        {\n', '            difficulty = _MAXIMUM_TARGET;\n', '        }\n', '    }\n', '\n', '    function getChallengeNumber() public view returns(bytes32) {\n', '        return challengeNumber;\n', '    }\n', '\n', '    function getMiningDifficulty() public view returns(uint) {\n', '        return _MAXIMUM_TARGET.div(difficulty);\n', '    }\n', '\n', '    function getMiningTarget() public view returns(uint) {\n', '        return difficulty;\n', '    }\n', '\n', '    function getMiningReward() public view returns(uint) {\n', '        return (baseMiningReward * 1e8).div(2 ** rewardEra);\n', '    }\n', '\n', '    function getMintDigest(\n', '        uint256 nonce,\n', '        bytes32 challenge_digest,\n', '        bytes32 challenge_number\n', '    )\n', '    public view returns(bytes32 digesttest) {\n', '        bytes32 digest = keccak256(challenge_number, msg.sender, nonce);\n', '        return digest;\n', '    }\n', '\n', '    function checkMintSolution(\n', '        uint256 nonce,\n', '        bytes32 challenge_digest,\n', '        bytes32 challenge_number,\n', '        uint testTarget\n', '    )\n', '    public view returns(bool success) {\n', '        bytes32 digest = keccak256(challenge_number, msg.sender, nonce);\n', '        if (uint256(digest) > testTarget) revert();\n', '        return (digest == challenge_digest);\n', '    }\n', '}\n', '\n', 'contract CaelumMiner is CaelumAbstractMiner {\n', '\n', '    ICaelumToken public tokenInterface;\n', '    ICaelumMasternode public masternodeInterface;\n', '    bool public ACTIVE_STATE = false;\n', '    uint swapStartedBlock = now;\n', '    uint public gasPriceLimit = 999;\n', '\n', '    /**\n', '     * @dev Allows the owner to set a gas limit on submitting solutions.\n', '     * courtesy of KiwiToken.\n', '     * See https://github.com/liberation-online/MineableToken for more details why.\n', '     */\n', '\n', '    modifier checkGasPrice(uint txnGasPrice) {\n', '        require(txnGasPrice <= gasPriceLimit * 1000000000, "Gas above gwei limit!");\n', '        _;\n', '    }\n', '\n', '    event GasPriceSet(uint8 _gasPrice);\n', '\n', '    function setGasPriceLimit(uint8 _gasPrice) onlyOwner public {\n', '        require(_gasPrice > 0);\n', '        gasPriceLimit = _gasPrice;\n', '\n', '        emit GasPriceSet(_gasPrice); //emit event\n', '    }\n', '\n', '    function setTokenContract() internal {\n', '        tokenInterface = ICaelumToken(_contract_token());\n', '    }\n', '\n', '    function setMasternodeContract() internal {\n', '        masternodeInterface = ICaelumMasternode(_contract_masternode());\n', '    }\n', '\n', '    /**\n', '     * Override; For some reason, truffle testing does not recognize function.\n', '     */\n', '    function setModifierContract (address _contract) onlyOwner public {\n', '        require (now <= swapStartedBlock + 10 days);\n', '        _internalMod = InterfaceContracts(_contract);\n', '        setMasternodeContract();\n', '        setTokenContract();\n', '    }\n', '\n', '    /**\n', '    * @dev Move the voting away from token. All votes will be made from the voting\n', '    */\n', '    function VoteModifierContract (address _contract) onlyVotingContract external {\n', '        //_internalMod = CaelumModifierAbstract(_contract);\n', '        _internalMod = InterfaceContracts(_contract);\n', '        setMasternodeContract();\n', '        setTokenContract();\n', '    }\n', '\n', '    function mint(uint256 nonce, bytes32 challenge_digest) checkGasPrice(tx.gasprice) public returns(bool success) {\n', '        require(ACTIVE_STATE);\n', '\n', '        _hash(nonce, challenge_digest);\n', '\n', '        masternodeInterface._externalArrangeFlow();\n', '\n', '        uint rewardAmount = _reward();\n', '        uint rewardMasternode = _reward_masternode();\n', '\n', '        tokensMinted += rewardAmount.add(rewardMasternode);\n', '\n', '        uint epochCounter = _newEpoch(nonce);\n', '\n', '        _adjustDifficulty();\n', '\n', '        statistics = Statistics(msg.sender, rewardAmount, block.number, now);\n', '\n', '        emit Mint(msg.sender, rewardAmount, epochCounter, challengeNumber);\n', '\n', '        return true;\n', '    }\n', '\n', '    function _reward() internal returns(uint) {\n', '\n', '        uint _pow = masternodeInterface.rewardsProofOfWork();\n', '\n', '        tokenInterface.rewardExternal(msg.sender, 1 * 1e8);\n', '\n', '        return _pow;\n', '    }\n', '\n', '    function _reward_masternode() internal returns(uint) {\n', '\n', '        uint _mnReward = masternodeInterface.rewardsMasternode();\n', '        if (masternodeInterface.masternodeIDcounter() == 0) return 0;\n', '\n', '        address _mnCandidate = masternodeInterface.getUserFromID(masternodeInterface.masternodeCandidate()); // userByIndex[masternodeCandidate].accountOwner;\n', '        if (_mnCandidate == 0x0) return 0;\n', '\n', '        tokenInterface.rewardExternal(_mnCandidate, _mnReward);\n', '\n', '        emit RewardMasternode(_mnCandidate, _mnReward);\n', '\n', '        return _mnReward;\n', '    }\n', '\n', '    /**\n', '     * @dev Fetch data from the actual reward. We do this to prevent pools payout out\n', '     * the global reward instead of the calculated ones.\n', '     * By default, pools fetch the `getMiningReward()` value and will payout this amount.\n', '     */\n', '    function getMiningRewardForPool() public view returns(uint) {\n', '        return masternodeInterface.rewardsProofOfWork();\n', '    }\n', '\n', '    function getMiningReward() public view returns(uint) {\n', '        return (baseMiningReward * 1e8).div(2 ** rewardEra);\n', '    }\n', '\n', '    function contractProgress() public view returns\n', '        (\n', '            uint epoch,\n', '            uint candidate,\n', '            uint round,\n', '            uint miningepoch,\n', '            uint globalreward,\n', '            uint powreward,\n', '            uint masternodereward,\n', '            uint usercounter\n', '        ) {\n', '            return ICaelumMasternode(_contract_masternode()).contractProgress();\n', '\n', '        }\n', '\n', '    /**\n', '     * @dev Call this function prior to mining to copy all old contract values.\n', '     * This included minted tokens, difficulty, etc..\n', '     */\n', '\n', '    function getDataFromContract(address _previous_contract) onlyOwner public {\n', '        require(ACTIVE_STATE == false);\n', '        require(_contract_token() != 0);\n', '        require(_contract_masternode() != 0);\n', '\n', '        CaelumAbstractMiner prev = CaelumAbstractMiner(_previous_contract);\n', '        difficulty = prev.difficulty();\n', '        rewardEra = prev.rewardEra();\n', '        MINING_RATE_FACTOR = prev.MINING_RATE_FACTOR();\n', '        maxSupplyForEra = prev.maxSupplyForEra();\n', '        tokensMinted = prev.tokensMinted();\n', '        epochCount = prev.epochCount();\n', '\n', '        ACTIVE_STATE = true;\n', '    }\n', '}']