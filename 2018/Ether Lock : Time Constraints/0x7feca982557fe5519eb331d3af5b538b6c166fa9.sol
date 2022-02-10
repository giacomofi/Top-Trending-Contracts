['pragma solidity ^0.4.18;\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', '// &#39;Yiha&#39; contract\n', '\n', '// Mineable ERC20 Token using Proof Of Work\n', '\n', '//\n', '\n', '// Symbol      : YIHA\n', '\n', '// Name        : Yiha\n', '\n', '// Total supply: 250,000,000.00\n', '\n', '// Decimals    : 8\n', '\n', '//\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', '// Safe maths\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', 'library SafeMath {\n', '\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '\n', '        c = a + b;\n', '\n', '        require(c >= a);\n', '\n', '    }\n', '\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '\n', '        require(b <= a);\n', '\n', '        c = a - b;\n', '\n', '    }\n', '\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '\n', '        c = a * b;\n', '\n', '        require(a == 0 || c / a == b);\n', '\n', '    }\n', '\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '\n', '        require(b > 0);\n', '\n', '        c = a / b;\n', '\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', 'library ExtendedMath {\n', '\n', '\n', '    //return the smaller of the two inputs (a or b)\n', '    function limitLessThan(uint a, uint b) internal pure returns (uint c) {\n', '\n', '        if(a > b) return b;\n', '\n', '        return a;\n', '\n', '    }\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', '// ERC Token Standard #20 Interface\n', '\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', 'contract ERC20Interface {\n', '\n', '    function totalSupply() public constant returns (uint);\n', '\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '\n', '}\n', '\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', '// Contract function to receive approval and execute function in one call\n', '\n', '//\n', '\n', '// Borrowed from MiniMeToken\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', 'contract ApproveAndCallFallBack {\n', '\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;\n', '\n', '}\n', '\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', '// Owned contract\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', 'contract Owned {\n', '\n', '    address public owner;\n', '\n', '    address public newOwner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '\n', '    function Owned() public {\n', '\n', '        owner = msg.sender;\n', '\n', '    }\n', '\n', '\n', '    modifier onlyOwner {\n', '\n', '        require(msg.sender == owner);\n', '\n', '        _;\n', '\n', '    }\n', '\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '\n', '        newOwner = _newOwner;\n', '\n', '    }\n', '\n', '    function acceptOwnership() public {\n', '\n', '        require(msg.sender == newOwner);\n', '\n', '        OwnershipTransferred(owner, newOwner);\n', '\n', '        owner = newOwner;\n', '\n', '        newOwner = address(0);\n', '\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', '// ERC20 Token, with the addition of symbol, name and decimals and an\n', '\n', '// initial fixed supply\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', 'contract Yiha is ERC20Interface, Owned {\n', '\n', '    using SafeMath for uint;\n', '    using ExtendedMath for uint;\n', '\n', '\n', '    string public symbol;\n', '\n', '    string public  name;\n', '\n', '    uint8 public decimals;\n', '\n', '    uint public _totalSupply;\n', '\n', '\n', '\n', '     uint public latestDifficultyPeriodStarted;\n', '\n', '\n', '\n', '    uint public epochCount;//number of &#39;blocks&#39; mined\n', '\n', '\n', '    uint public _BLOCKS_PER_READJUSTMENT = 1024;\n', '\n', '\n', '    //a little number\n', '    uint public  _MINIMUM_TARGET = 2**16;\n', '\n', '\n', '      //a big number is easier ; just find a solution that is smaller\n', '    //uint public  _MAXIMUM_TARGET = 2**224;  bitcoin uses 224\n', '    uint public  _MAXIMUM_TARGET = 2**234;\n', '    uint public _START_TARGET = 2**227;\n', '\n', '    uint public miningTarget;\n', '\n', '    bytes32 public challengeNumber;   //generate a new one when a new reward is minted\n', '\n', '\n', '\n', '    uint public rewardEra;\n', '    uint public maxSupplyForEra;\n', '\n', '\n', '    address public lastRewardTo;\n', '    uint public lastRewardAmount;\n', '    uint public lastRewardEthBlockNumber;\n', '\n', '    bool locked = false;\n', '\n', '    mapping(bytes32 => bytes32) solutionForChallenge;\n', '\n', '    uint public tokensMinted;\n', '\n', '    mapping(address => uint) balances;\n', '\n', '\n', '    mapping(address => mapping(address => uint)) allowed;\n', '\n', '\n', '    event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    // Constructor\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    function Yiha() public onlyOwner{\n', '\n', '\n', '\n', '        symbol = "YIHA";\n', '\n', '        name = "Yiha";\n', '\n', '        decimals = 8;\n', '\n', '        _totalSupply = 250000000 * 10**uint(decimals);\n', '\n', '        if(locked) revert();\n', '        locked = true;\n', '\n', '        tokensMinted = 0;\n', '\n', '        rewardEra = 0;\n', '        maxSupplyForEra = _totalSupply.div(2);\n', '\n', '        miningTarget = _START_TARGET;\n', '\n', '        latestDifficultyPeriodStarted = block.number;\n', '\n', '        _startNewMiningEpoch();\n', '\n', '        balances[owner] = 50000000 * 10**uint(decimals);\n', '        Transfer(address(0), owner, 50000000 * 10**uint(decimals));\n', '\n', '    }\n', '\n', '\n', '\n', '\n', '        function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success) {\n', '\n', '\n', '            //the PoW must contain work that includes a recent ethereum block hash (challenge number) and the msg.sender&#39;s address to prevent MITM attacks\n', '            bytes32 digest =  keccak256(challengeNumber, msg.sender, nonce );\n', '\n', '            //the challenge digest must match the expected\n', '            if (digest != challenge_digest) revert();\n', '\n', '            //the digest must be smaller than the target\n', '            if(uint256(digest) > miningTarget) revert();\n', '\n', '\n', '            //only allow one reward for each challenge\n', '             bytes32 solution = solutionForChallenge[challengeNumber];\n', '             solutionForChallenge[challengeNumber] = digest;\n', '             if(solution != 0x0) revert();  //prevent the same answer from awarding twice\n', '\n', '\n', '            uint reward_amount = getMiningReward();\n', '\n', '            balances[msg.sender] = balances[msg.sender].add(reward_amount);\n', '\n', '            tokensMinted = tokensMinted.add(reward_amount);\n', '\n', '\n', '            //Cannot mint more tokens than there are\n', '            assert(tokensMinted <= maxSupplyForEra);\n', '\n', '            //set readonly diagnostics data\n', '            lastRewardTo = msg.sender;\n', '            lastRewardAmount = reward_amount;\n', '            lastRewardEthBlockNumber = block.number;\n', '\n', '\n', '             _startNewMiningEpoch();\n', '\n', '              Mint(msg.sender, reward_amount, epochCount, challengeNumber );\n', '\n', '           return true;\n', '\n', '        }\n', '\n', '\n', '    //a new &#39;block&#39; to be mined\n', '    function _startNewMiningEpoch() internal {\n', '\n', '      //if max supply for the era will be exceeded next reward round then enter the new era before that happens\n', '\n', '      //40 is the final reward era, almost all tokens minted\n', '      //once the final era is reached, more tokens will not be given out because the assert function\n', '      if( tokensMinted.add(getMiningReward()) > maxSupplyForEra && rewardEra < 39)\n', '      {\n', '        rewardEra = rewardEra + 1;\n', '      }\n', '\n', '      //set the next minted supply at which the era will change\n', '      // total supply is 2100000000000000  because of 8 decimal places\n', '      maxSupplyForEra = _totalSupply - _totalSupply.div( 2**(rewardEra + 1));\n', '\n', '      epochCount = epochCount.add(1);\n', '\n', '      //every so often, readjust difficulty. Dont readjust when deploying\n', '      if(epochCount % _BLOCKS_PER_READJUSTMENT == 0)\n', '      {\n', '        _reAdjustDifficulty();\n', '      }\n', '\n', '\n', '      //make the latest ethereum block hash a part of the next challenge for PoW to prevent pre-mining future blocks\n', '      //do this last since this is a protection mechanism in the mint() function\n', '      challengeNumber = block.blockhash(block.number - 1);\n', '\n', '\n', '\n', '\n', '\n', '\n', '    }\n', '\n', '\n', '\n', '\n', '    //https://en.bitcoin.it/wiki/Difficulty#What_is_the_formula_for_difficulty.3F\n', '    //as of 2017 the bitcoin difficulty was up to 17 zeroes, it was only 8 in the early days\n', '\n', '    //readjust the target by 5 percent\n', '    function _reAdjustDifficulty() internal {\n', '\n', '\n', '        uint ethBlocksSinceLastDifficultyPeriod = block.number - latestDifficultyPeriodStarted;\n', '        //assume 360 ethereum blocks per hour\n', '\n', '        //we want miners to spend 10 minutes to mine each &#39;block&#39;, about 60 ethereum blocks = one yiha epoch\n', '        uint epochsMined = _BLOCKS_PER_READJUSTMENT; //256\n', '\n', '        uint targetEthBlocksPerDiffPeriod = epochsMined * 60; //should be 60 times slower than ethereum\n', '\n', '        //if there were less eth blocks passed in time than expected\n', '        if( ethBlocksSinceLastDifficultyPeriod < targetEthBlocksPerDiffPeriod )\n', '        {\n', '          uint excess_block_pct = (targetEthBlocksPerDiffPeriod.mul(100)).div( ethBlocksSinceLastDifficultyPeriod );\n', '\n', '          uint excess_block_pct_extra = excess_block_pct.sub(100).limitLessThan(1000);\n', '          // If there were 5% more blocks mined than expected then this is 5.  If there were 100% more blocks mined than expected then this is 100.\n', '\n', '          //make it harder\n', '          miningTarget = miningTarget.sub(miningTarget.div(2000).mul(excess_block_pct_extra));   //by up to 50 %\n', '        }else{\n', '          uint shortage_block_pct = (ethBlocksSinceLastDifficultyPeriod.mul(100)).div( targetEthBlocksPerDiffPeriod );\n', '\n', '          uint shortage_block_pct_extra = shortage_block_pct.sub(100).limitLessThan(1000); //always between 0 and 1000\n', '\n', '          //make it easier\n', '          miningTarget = miningTarget.add(miningTarget.div(2000).mul(shortage_block_pct_extra));   //by up to 50 %\n', '        }\n', '\n', '\n', '\n', '        latestDifficultyPeriodStarted = block.number;\n', '\n', '        if(miningTarget < _MINIMUM_TARGET) //very difficult\n', '        {\n', '          miningTarget = _MINIMUM_TARGET;\n', '        }\n', '\n', '        if(miningTarget > _MAXIMUM_TARGET) //very easy\n', '        {\n', '          miningTarget = _MAXIMUM_TARGET;\n', '        }\n', '    }\n', '\n', '\n', '    //this is a recent ethereum block hash, used to prevent pre-mining future blocks\n', '    function getChallengeNumber() public constant returns (bytes32) {\n', '        return challengeNumber;\n', '    }\n', '\n', '    //the number of zeroes the digest of the PoW solution requires.  Auto adjusts\n', '     function getMiningDifficulty() public constant returns (uint) {\n', '        return _MAXIMUM_TARGET.div(miningTarget);\n', '    }\n', '\n', '    function getMiningTarget() public constant returns (uint) {\n', '       return miningTarget;\n', '   }\n', '\n', '\n', '\n', '    //21m coins total\n', '    //reward begins at 50 and is cut in half every reward era (as tokens are mined)\n', '    function getMiningReward() public constant returns (uint) {\n', '        //once we get half way thru the coins, only get 25 per block\n', '\n', '         //every reward era, the reward amount halves.\n', '\n', '         return (50 * 10**uint(decimals) ).div( 2**rewardEra ) ;\n', '\n', '    }\n', '\n', '    //help debug mining software\n', '    function getMintDigest(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number) public view returns (bytes32 digesttest) {\n', '\n', '        bytes32 digest = keccak256(challenge_number,msg.sender,nonce);\n', '\n', '        return digest;\n', '\n', '      }\n', '\n', '        //help debug mining software\n', '      function checkMintSolution(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number, uint testTarget) public view returns (bool success) {\n', '\n', '          bytes32 digest = keccak256(challenge_number,msg.sender,nonce);\n', '\n', '          if(uint256(digest) > testTarget) revert();\n', '\n', '          return (digest == challenge_digest);\n', '\n', '        }\n', '\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    // Total supply\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    function totalSupply() public constant returns (uint) {\n', '\n', '        return _totalSupply  - balances[address(0)];\n', '\n', '    }\n', '\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    // Get the token balance for account `tokenOwner`\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance) {\n', '\n', '        return balances[tokenOwner];\n', '\n', '    }\n', '\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    // Transfer the balance from token owner&#39;s account to `to` account\n', '\n', '    // - Owner&#39;s account must have sufficient balance to transfer\n', '\n', '    // - 0 value transfers are allowed\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '\n', '        balances[to] = balances[to].add(tokens);\n', '\n', '        Transfer(msg.sender, to, tokens);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', '\n', '    // from the token owner&#39;s account\n', '\n', '    //\n', '\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '\n', '    // recommends that there are no checks for the approval double-spend attack\n', '\n', '    // as this should be implemented in user interfaces\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '\n', '        allowed[msg.sender][spender] = tokens;\n', '\n', '        Approval(msg.sender, spender, tokens);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '\n', '    //\n', '\n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '\n', '    // for spending from the `from` account and\n', '\n', '    // - From account must have sufficient balance to transfer\n', '\n', '    // - Spender must have sufficient allowance to transfer\n', '\n', '    // - 0 value transfers are allowed\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '\n', '        balances[from] = balances[from].sub(tokens);\n', '\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '\n', '        balances[to] = balances[to].add(tokens);\n', '\n', '        Transfer(from, to, tokens);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    // Returns the amount of tokens approved by the owner that can be\n', '\n', '    // transferred to the spender&#39;s account\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {\n', '\n', '        return allowed[tokenOwner][spender];\n', '\n', '    }\n', '\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', '\n', '    // from the token owner&#39;s account. The `spender` contract function\n', '\n', '    // `receiveApproval(...)` is then executed\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {\n', '\n', '        allowed[msg.sender][spender] = tokens;\n', '\n', '        Approval(msg.sender, spender, tokens);\n', '\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    // Don&#39;t accept ETH\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    function () public payable {\n', '\n', '        revert();\n', '\n', '    }\n', '\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    // Owner can transfer out any accidentally sent ERC20 tokens\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {\n', '\n', '        return ERC20Interface(tokenAddress).transfer(owner, tokens);\n', '\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.18;\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', "// 'Yiha' contract\n", '\n', '// Mineable ERC20 Token using Proof Of Work\n', '\n', '//\n', '\n', '// Symbol      : YIHA\n', '\n', '// Name        : Yiha\n', '\n', '// Total supply: 250,000,000.00\n', '\n', '// Decimals    : 8\n', '\n', '//\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', '// Safe maths\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', 'library SafeMath {\n', '\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '\n', '        c = a + b;\n', '\n', '        require(c >= a);\n', '\n', '    }\n', '\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '\n', '        require(b <= a);\n', '\n', '        c = a - b;\n', '\n', '    }\n', '\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '\n', '        c = a * b;\n', '\n', '        require(a == 0 || c / a == b);\n', '\n', '    }\n', '\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '\n', '        require(b > 0);\n', '\n', '        c = a / b;\n', '\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', 'library ExtendedMath {\n', '\n', '\n', '    //return the smaller of the two inputs (a or b)\n', '    function limitLessThan(uint a, uint b) internal pure returns (uint c) {\n', '\n', '        if(a > b) return b;\n', '\n', '        return a;\n', '\n', '    }\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', '// ERC Token Standard #20 Interface\n', '\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', 'contract ERC20Interface {\n', '\n', '    function totalSupply() public constant returns (uint);\n', '\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '\n', '}\n', '\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', '// Contract function to receive approval and execute function in one call\n', '\n', '//\n', '\n', '// Borrowed from MiniMeToken\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', 'contract ApproveAndCallFallBack {\n', '\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;\n', '\n', '}\n', '\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', '// Owned contract\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', 'contract Owned {\n', '\n', '    address public owner;\n', '\n', '    address public newOwner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '\n', '    function Owned() public {\n', '\n', '        owner = msg.sender;\n', '\n', '    }\n', '\n', '\n', '    modifier onlyOwner {\n', '\n', '        require(msg.sender == owner);\n', '\n', '        _;\n', '\n', '    }\n', '\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '\n', '        newOwner = _newOwner;\n', '\n', '    }\n', '\n', '    function acceptOwnership() public {\n', '\n', '        require(msg.sender == newOwner);\n', '\n', '        OwnershipTransferred(owner, newOwner);\n', '\n', '        owner = newOwner;\n', '\n', '        newOwner = address(0);\n', '\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', '// ERC20 Token, with the addition of symbol, name and decimals and an\n', '\n', '// initial fixed supply\n', '\n', '// ----------------------------------------------------------------------------\n', '\n', 'contract Yiha is ERC20Interface, Owned {\n', '\n', '    using SafeMath for uint;\n', '    using ExtendedMath for uint;\n', '\n', '\n', '    string public symbol;\n', '\n', '    string public  name;\n', '\n', '    uint8 public decimals;\n', '\n', '    uint public _totalSupply;\n', '\n', '\n', '\n', '     uint public latestDifficultyPeriodStarted;\n', '\n', '\n', '\n', "    uint public epochCount;//number of 'blocks' mined\n", '\n', '\n', '    uint public _BLOCKS_PER_READJUSTMENT = 1024;\n', '\n', '\n', '    //a little number\n', '    uint public  _MINIMUM_TARGET = 2**16;\n', '\n', '\n', '      //a big number is easier ; just find a solution that is smaller\n', '    //uint public  _MAXIMUM_TARGET = 2**224;  bitcoin uses 224\n', '    uint public  _MAXIMUM_TARGET = 2**234;\n', '    uint public _START_TARGET = 2**227;\n', '\n', '    uint public miningTarget;\n', '\n', '    bytes32 public challengeNumber;   //generate a new one when a new reward is minted\n', '\n', '\n', '\n', '    uint public rewardEra;\n', '    uint public maxSupplyForEra;\n', '\n', '\n', '    address public lastRewardTo;\n', '    uint public lastRewardAmount;\n', '    uint public lastRewardEthBlockNumber;\n', '\n', '    bool locked = false;\n', '\n', '    mapping(bytes32 => bytes32) solutionForChallenge;\n', '\n', '    uint public tokensMinted;\n', '\n', '    mapping(address => uint) balances;\n', '\n', '\n', '    mapping(address => mapping(address => uint)) allowed;\n', '\n', '\n', '    event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    // Constructor\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    function Yiha() public onlyOwner{\n', '\n', '\n', '\n', '        symbol = "YIHA";\n', '\n', '        name = "Yiha";\n', '\n', '        decimals = 8;\n', '\n', '        _totalSupply = 250000000 * 10**uint(decimals);\n', '\n', '        if(locked) revert();\n', '        locked = true;\n', '\n', '        tokensMinted = 0;\n', '\n', '        rewardEra = 0;\n', '        maxSupplyForEra = _totalSupply.div(2);\n', '\n', '        miningTarget = _START_TARGET;\n', '\n', '        latestDifficultyPeriodStarted = block.number;\n', '\n', '        _startNewMiningEpoch();\n', '\n', '        balances[owner] = 50000000 * 10**uint(decimals);\n', '        Transfer(address(0), owner, 50000000 * 10**uint(decimals));\n', '\n', '    }\n', '\n', '\n', '\n', '\n', '        function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success) {\n', '\n', '\n', "            //the PoW must contain work that includes a recent ethereum block hash (challenge number) and the msg.sender's address to prevent MITM attacks\n", '            bytes32 digest =  keccak256(challengeNumber, msg.sender, nonce );\n', '\n', '            //the challenge digest must match the expected\n', '            if (digest != challenge_digest) revert();\n', '\n', '            //the digest must be smaller than the target\n', '            if(uint256(digest) > miningTarget) revert();\n', '\n', '\n', '            //only allow one reward for each challenge\n', '             bytes32 solution = solutionForChallenge[challengeNumber];\n', '             solutionForChallenge[challengeNumber] = digest;\n', '             if(solution != 0x0) revert();  //prevent the same answer from awarding twice\n', '\n', '\n', '            uint reward_amount = getMiningReward();\n', '\n', '            balances[msg.sender] = balances[msg.sender].add(reward_amount);\n', '\n', '            tokensMinted = tokensMinted.add(reward_amount);\n', '\n', '\n', '            //Cannot mint more tokens than there are\n', '            assert(tokensMinted <= maxSupplyForEra);\n', '\n', '            //set readonly diagnostics data\n', '            lastRewardTo = msg.sender;\n', '            lastRewardAmount = reward_amount;\n', '            lastRewardEthBlockNumber = block.number;\n', '\n', '\n', '             _startNewMiningEpoch();\n', '\n', '              Mint(msg.sender, reward_amount, epochCount, challengeNumber );\n', '\n', '           return true;\n', '\n', '        }\n', '\n', '\n', "    //a new 'block' to be mined\n", '    function _startNewMiningEpoch() internal {\n', '\n', '      //if max supply for the era will be exceeded next reward round then enter the new era before that happens\n', '\n', '      //40 is the final reward era, almost all tokens minted\n', '      //once the final era is reached, more tokens will not be given out because the assert function\n', '      if( tokensMinted.add(getMiningReward()) > maxSupplyForEra && rewardEra < 39)\n', '      {\n', '        rewardEra = rewardEra + 1;\n', '      }\n', '\n', '      //set the next minted supply at which the era will change\n', '      // total supply is 2100000000000000  because of 8 decimal places\n', '      maxSupplyForEra = _totalSupply - _totalSupply.div( 2**(rewardEra + 1));\n', '\n', '      epochCount = epochCount.add(1);\n', '\n', '      //every so often, readjust difficulty. Dont readjust when deploying\n', '      if(epochCount % _BLOCKS_PER_READJUSTMENT == 0)\n', '      {\n', '        _reAdjustDifficulty();\n', '      }\n', '\n', '\n', '      //make the latest ethereum block hash a part of the next challenge for PoW to prevent pre-mining future blocks\n', '      //do this last since this is a protection mechanism in the mint() function\n', '      challengeNumber = block.blockhash(block.number - 1);\n', '\n', '\n', '\n', '\n', '\n', '\n', '    }\n', '\n', '\n', '\n', '\n', '    //https://en.bitcoin.it/wiki/Difficulty#What_is_the_formula_for_difficulty.3F\n', '    //as of 2017 the bitcoin difficulty was up to 17 zeroes, it was only 8 in the early days\n', '\n', '    //readjust the target by 5 percent\n', '    function _reAdjustDifficulty() internal {\n', '\n', '\n', '        uint ethBlocksSinceLastDifficultyPeriod = block.number - latestDifficultyPeriodStarted;\n', '        //assume 360 ethereum blocks per hour\n', '\n', "        //we want miners to spend 10 minutes to mine each 'block', about 60 ethereum blocks = one yiha epoch\n", '        uint epochsMined = _BLOCKS_PER_READJUSTMENT; //256\n', '\n', '        uint targetEthBlocksPerDiffPeriod = epochsMined * 60; //should be 60 times slower than ethereum\n', '\n', '        //if there were less eth blocks passed in time than expected\n', '        if( ethBlocksSinceLastDifficultyPeriod < targetEthBlocksPerDiffPeriod )\n', '        {\n', '          uint excess_block_pct = (targetEthBlocksPerDiffPeriod.mul(100)).div( ethBlocksSinceLastDifficultyPeriod );\n', '\n', '          uint excess_block_pct_extra = excess_block_pct.sub(100).limitLessThan(1000);\n', '          // If there were 5% more blocks mined than expected then this is 5.  If there were 100% more blocks mined than expected then this is 100.\n', '\n', '          //make it harder\n', '          miningTarget = miningTarget.sub(miningTarget.div(2000).mul(excess_block_pct_extra));   //by up to 50 %\n', '        }else{\n', '          uint shortage_block_pct = (ethBlocksSinceLastDifficultyPeriod.mul(100)).div( targetEthBlocksPerDiffPeriod );\n', '\n', '          uint shortage_block_pct_extra = shortage_block_pct.sub(100).limitLessThan(1000); //always between 0 and 1000\n', '\n', '          //make it easier\n', '          miningTarget = miningTarget.add(miningTarget.div(2000).mul(shortage_block_pct_extra));   //by up to 50 %\n', '        }\n', '\n', '\n', '\n', '        latestDifficultyPeriodStarted = block.number;\n', '\n', '        if(miningTarget < _MINIMUM_TARGET) //very difficult\n', '        {\n', '          miningTarget = _MINIMUM_TARGET;\n', '        }\n', '\n', '        if(miningTarget > _MAXIMUM_TARGET) //very easy\n', '        {\n', '          miningTarget = _MAXIMUM_TARGET;\n', '        }\n', '    }\n', '\n', '\n', '    //this is a recent ethereum block hash, used to prevent pre-mining future blocks\n', '    function getChallengeNumber() public constant returns (bytes32) {\n', '        return challengeNumber;\n', '    }\n', '\n', '    //the number of zeroes the digest of the PoW solution requires.  Auto adjusts\n', '     function getMiningDifficulty() public constant returns (uint) {\n', '        return _MAXIMUM_TARGET.div(miningTarget);\n', '    }\n', '\n', '    function getMiningTarget() public constant returns (uint) {\n', '       return miningTarget;\n', '   }\n', '\n', '\n', '\n', '    //21m coins total\n', '    //reward begins at 50 and is cut in half every reward era (as tokens are mined)\n', '    function getMiningReward() public constant returns (uint) {\n', '        //once we get half way thru the coins, only get 25 per block\n', '\n', '         //every reward era, the reward amount halves.\n', '\n', '         return (50 * 10**uint(decimals) ).div( 2**rewardEra ) ;\n', '\n', '    }\n', '\n', '    //help debug mining software\n', '    function getMintDigest(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number) public view returns (bytes32 digesttest) {\n', '\n', '        bytes32 digest = keccak256(challenge_number,msg.sender,nonce);\n', '\n', '        return digest;\n', '\n', '      }\n', '\n', '        //help debug mining software\n', '      function checkMintSolution(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number, uint testTarget) public view returns (bool success) {\n', '\n', '          bytes32 digest = keccak256(challenge_number,msg.sender,nonce);\n', '\n', '          if(uint256(digest) > testTarget) revert();\n', '\n', '          return (digest == challenge_digest);\n', '\n', '        }\n', '\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    // Total supply\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    function totalSupply() public constant returns (uint) {\n', '\n', '        return _totalSupply  - balances[address(0)];\n', '\n', '    }\n', '\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    // Get the token balance for account `tokenOwner`\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance) {\n', '\n', '        return balances[tokenOwner];\n', '\n', '    }\n', '\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', "    // Transfer the balance from token owner's account to `to` account\n", '\n', "    // - Owner's account must have sufficient balance to transfer\n", '\n', '    // - 0 value transfers are allowed\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '\n', '        balances[to] = balances[to].add(tokens);\n', '\n', '        Transfer(msg.sender, to, tokens);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', '\n', "    // from the token owner's account\n", '\n', '    //\n', '\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '\n', '    // recommends that there are no checks for the approval double-spend attack\n', '\n', '    // as this should be implemented in user interfaces\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '\n', '        allowed[msg.sender][spender] = tokens;\n', '\n', '        Approval(msg.sender, spender, tokens);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '\n', '    //\n', '\n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '\n', '    // for spending from the `from` account and\n', '\n', '    // - From account must have sufficient balance to transfer\n', '\n', '    // - Spender must have sufficient allowance to transfer\n', '\n', '    // - 0 value transfers are allowed\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '\n', '        balances[from] = balances[from].sub(tokens);\n', '\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '\n', '        balances[to] = balances[to].add(tokens);\n', '\n', '        Transfer(from, to, tokens);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    // Returns the amount of tokens approved by the owner that can be\n', '\n', "    // transferred to the spender's account\n", '\n', '    // ------------------------------------------------------------------------\n', '\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {\n', '\n', '        return allowed[tokenOwner][spender];\n', '\n', '    }\n', '\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', '\n', "    // from the token owner's account. The `spender` contract function\n", '\n', '    // `receiveApproval(...)` is then executed\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {\n', '\n', '        allowed[msg.sender][spender] = tokens;\n', '\n', '        Approval(msg.sender, spender, tokens);\n', '\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', "    // Don't accept ETH\n", '\n', '    // ------------------------------------------------------------------------\n', '\n', '    function () public payable {\n', '\n', '        revert();\n', '\n', '    }\n', '\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    // Owner can transfer out any accidentally sent ERC20 tokens\n', '\n', '    // ------------------------------------------------------------------------\n', '\n', '    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {\n', '\n', '        return ERC20Interface(tokenAddress).transfer(owner, tokens);\n', '\n', '    }\n', '\n', '}']
