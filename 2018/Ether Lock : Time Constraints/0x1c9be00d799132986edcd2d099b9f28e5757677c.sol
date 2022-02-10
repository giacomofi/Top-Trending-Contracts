['pragma solidity ^0.4.21;\n', '\n', '// ----------------------------------------------------------------------------\n', '// &#39;PoWEth Token&#39; contract\n', '// Mineable ERC20 Token using Proof Of Work\n', '//\n', '// Symbol      : PoWEth\n', '// Name        : PoWEth Token\n', '// Total supply: 100,000,000.00\n', '// Decimals    : 8\n', '//\n', '// ----------------------------------------------------------------------------\n', '\n', '// ----------------------------------------------------------------------------\n', '// Safe maths\n', '// ----------------------------------------------------------------------------\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '}\n', '\n', 'library ExtendedMath {\n', '    //return the smaller of the two inputs (a or b)\n', '    function limitLessThan(uint a, uint b) internal pure returns (uint c) {\n', '        if(a > b) return b;\n', '        return a;\n', '    }\n', '}\n', '\n', 'contract ERC20Interface {\n', '\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC20 Token, with the addition of symbol, name and decimals and an\n', '// initial fixed supply\n', '// ----------------------------------------------------------------------------\n', 'contract _0xEtherToken is ERC20Interface {\n', '    using SafeMath for uint;\n', '    using ExtendedMath for uint;\n', '\n', '    string public symbol = "PoWEth";\n', '    string public name = "PoWEth Token";\n', '    uint8 public decimals = 8;\n', '    uint public _totalSupply = 10000000000000000;\n', '\tuint public maxSupplyForEra = 5000000000000000;\n', '\t\n', '    uint public latestDifficultyPeriodStarted;\n', '\tuint public tokensMinted;\n', '\t\n', '    uint public epochCount; //number of &#39;blocks&#39; mined\n', '    uint public _BLOCKS_PER_READJUSTMENT = 1024;\n', '\n', '    uint public  _MINIMUM_TARGET = 2**16;\n', '    uint public  _MAXIMUM_TARGET = 2**234;\n', '\n', '    uint public miningTarget = _MAXIMUM_TARGET;\n', '\n', '    bytes32 public challengeNumber;   //generate a new one when a new reward is minted\n', '\n', '    uint public rewardEra;\n', '    \n', '    address public lastRewardTo;\n', '    uint public lastRewardAmount;\n', '    uint public lastRewardEthBlockNumber;\n', '\n', '    mapping(bytes32 => bytes32) solutionForChallenge;\n', '\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '    \n', '    address private owner;\n', '\n', '    event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);\n', '\n', '    function _0xEtherToken() public {\n', '        \n', '        owner = msg.sender;\n', '        \n', '        latestDifficultyPeriodStarted = block.number;\n', '\n', '        _startNewMiningEpoch();\n', '\n', '        //The owner gets nothing! You must mine this ERC20 token\n', '        //balances[owner] = _totalSupply;\n', '        //Transfer(address(0), owner, _totalSupply);\n', '    }\n', '\n', '\tfunction mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success) {\n', '\n', '\t\t//the PoW must contain work that includes a recent ethereum block hash (challenge number) and the msg.sender&#39;s address to prevent MITM attacks\n', '\t\tbytes32 digest = keccak256(challengeNumber, msg.sender, nonce );\n', '\n', '\t\t//the challenge digest must match the expected\n', '\t\tif (digest != challenge_digest) revert();\n', '\n', '\t\t//the digest must be smaller than the target\n', '\t\tif(uint256(digest) > miningTarget) revert();\n', '\n', '\t\t//only allow one reward for each challenge\n', '\t\tbytes32 solution = solutionForChallenge[challengeNumber];\n', '\t\tsolutionForChallenge[challengeNumber] = digest;\n', '\t\tif(solution != 0x0) \n', '\t\t\trevert();  //prevent the same answer from awarding twice\n', '\n', '\t\tuint reward_amount = getMiningReward();\n', '\n', '\t\tbalances[msg.sender] = balances[msg.sender].add(reward_amount);\n', '\n', '\t\ttokensMinted = tokensMinted.add(reward_amount);\n', '\n', '\t\t//Cannot mint more tokens than there are\n', '\t\tassert(tokensMinted <= maxSupplyForEra);\n', '\n', '\t\t//set readonly diagnostics data\n', '\t\tlastRewardTo = msg.sender;\n', '\t\tlastRewardAmount = reward_amount;\n', '\t\tlastRewardEthBlockNumber = block.number;\n', '\t\t\n', '\t\t_startNewMiningEpoch();\n', '    \temit Mint(msg.sender, reward_amount, epochCount, challengeNumber );\n', '\n', '\t   return true;\n', '\t}\n', '\n', '    //a new &#39;block&#39; to be mined\n', '    function _startNewMiningEpoch() internal {\n', '\t\t//if max supply for the era will be exceeded next reward round then enter the new era before that happens\n', '\n', '\t\t//20 is the final reward era, almost all tokens minted\n', '\t\t//once the final era is reached, more tokens will not be given out because the assert function\n', '\t\t// 1 era is estimated 1,5y, 20 era is roughly 60y of mining time\n', '\t\tif( tokensMinted.add(getMiningReward()) > maxSupplyForEra && rewardEra < 19)\n', '\t\t{\n', '\t\t\trewardEra = rewardEra + 1;\n', '\t\t}\n', '\n', '\t\tmaxSupplyForEra = _totalSupply - _totalSupply / (2**(rewardEra + 1));\n', '\n', '\t\tepochCount = epochCount.add(1);\n', '\n', '\t\t//every so often, readjust difficulty. Dont readjust when deploying\n', '\t\tif(epochCount % _BLOCKS_PER_READJUSTMENT == 0)\n', '\t\t{\n', '\t\t\t_reAdjustDifficulty();\n', '\t\t}\n', '\n', '\t\t//make the latest ethereum block hash a part of the next challenge for PoW to prevent pre-mining future blocks\n', '\t\t//do this last since this is a protection mechanism in the mint() function\n', '\t\tchallengeNumber = block.blockhash(block.number - 1);\n', '    }\n', '\n', '    //https://en.bitcoin.it/wiki/Difficulty#What_is_the_formula_for_difficulty.3F\n', '    //as of 2017 the bitcoin difficulty was up to 17 zeroes, it was only 8 in the early days\n', '    //readjust the target by 5 percent\n', '    function _reAdjustDifficulty() internal {\n', '        uint ethBlocksSinceLastDifficultyPeriod = block.number - latestDifficultyPeriodStarted;\n', '        \n', '        //assume 240 ethereum blocks per hour\n', '        //we want miners to spend ~7,5 minutes to mine each &#39;block&#39;, about 30 ethereum blocks = 1 PoWEth epoch\n', '        uint targetEthBlocksPerDiffPeriod = _BLOCKS_PER_READJUSTMENT * 30; //should be 30 times slower than ethereum\n', '\n', '        //if there were less eth blocks passed in time than expected\n', '        if(ethBlocksSinceLastDifficultyPeriod < targetEthBlocksPerDiffPeriod)\n', '        {\n', '\t\t\tuint excess_block_pct = (targetEthBlocksPerDiffPeriod.mul(100)) / ethBlocksSinceLastDifficultyPeriod;\n', '\t\t\tuint excess_block_pct_extra = excess_block_pct.sub(100).limitLessThan(1000);\n', '\t\t\t\n', '\t\t\t//make it harder\n', '\t\t\tminingTarget = miningTarget.sub((miningTarget/2000).mul(excess_block_pct_extra));\n', '        }else{\n', '\t\t\tuint shortage_block_pct = (ethBlocksSinceLastDifficultyPeriod.mul(100)) / targetEthBlocksPerDiffPeriod;\n', '\t\t\tuint shortage_block_pct_extra = shortage_block_pct.sub(100).limitLessThan(1000);\n', '\n', '\t\t\t//make it easier\n', '\t\t\tminingTarget = miningTarget.add((miningTarget/2000).mul(shortage_block_pct_extra));\n', '        }\n', '\n', '        latestDifficultyPeriodStarted = block.number;\n', '\n', '        if(miningTarget < _MINIMUM_TARGET) //very difficult\n', '        {\n', '\t\t\tminingTarget = _MINIMUM_TARGET;\n', '        }\n', '\n', '        if(miningTarget > _MAXIMUM_TARGET) //very easy\n', '        {\n', '\t\t\tminingTarget = _MAXIMUM_TARGET;\n', '        }\n', '    }\n', '\n', '    //this is a recent ethereum block hash, used to prevent pre-mining future blocks\n', '    function getChallengeNumber() public constant returns (bytes32) {\n', '        return challengeNumber;\n', '    }\n', '\n', '    //the number of zeroes the digest of the PoW solution requires.  Auto adjusts\n', '     function getMiningDifficulty() public constant returns (uint) {\n', '        return _MAXIMUM_TARGET / miningTarget;\n', '    }\n', '\n', '    function getMiningTarget() public constant returns (uint) {\n', '       return miningTarget;\n', '\t}\n', '\n', '    //100m coins total\n', '    //reward begins at 250 and is cut in half every reward era (as tokens are mined)\n', '    function getMiningReward() public constant returns (uint) {\n', '\t\treturn 25000000000/(2**rewardEra);\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Total supply\n', '    // ------------------------------------------------------------------------\n', '    function totalSupply() public constant returns (uint) {\n', '        return _totalSupply  - balances[address(0)];\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account `tokenOwner`\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer the balance from token owner&#39;s account to `to` account\n', '    // - Owner&#39;s account must have sufficient balance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', '    // from the token owner&#39;s account\n', '    //\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '    // recommends that there are no checks for the approval double-spend attack\n', '    // as this should be implemented in user interfaces\n', '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '    //\n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the `from` account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '        balances[from] = balances[from].sub(tokens);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', '    // transferred to the spender&#39;s account\n', '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', '    // from the token owner&#39;s account. The `spender` contract function\n', '    // `receiveApproval(...)` is then executed\n', '    // ------------------------------------------------------------------------\n', '    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Don&#39;t accept ETH\n', '    // ------------------------------------------------------------------------\n', '    function () public payable {\n', '        revert();\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Owner can transfer out any accidentally sent ERC20 tokens\n', '    // ------------------------------------------------------------------------\n', '    function transferAnyERC20Token(address tokenAddress, uint tokens) public returns (bool success) {\n', '        require(msg.sender == owner);\n', '        return ERC20Interface(tokenAddress).transfer(owner, tokens);\n', '    }\n', '    \n', '    //help debug mining software\n', '    function getMintDigest(uint256 nonce, bytes32 challenge_number) public view returns (bytes32 digesttest) {\n', '        bytes32 digest = keccak256(challenge_number,msg.sender,nonce);\n', '        return digest;\n', '\t}\n', '\n', '\t//help debug mining software\n', '\tfunction checkMintSolution(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number, uint testTarget) public view returns (bool success) {\n', '\t\tbytes32 digest = keccak256(challenge_number,msg.sender,nonce);\n', '\t\tif(uint256(digest) > testTarget) \n', '\t\t\trevert();\n', '\t\treturn (digest == challenge_digest);\n', '\t}\n', '}']
['pragma solidity ^0.4.21;\n', '\n', '// ----------------------------------------------------------------------------\n', "// 'PoWEth Token' contract\n", '// Mineable ERC20 Token using Proof Of Work\n', '//\n', '// Symbol      : PoWEth\n', '// Name        : PoWEth Token\n', '// Total supply: 100,000,000.00\n', '// Decimals    : 8\n', '//\n', '// ----------------------------------------------------------------------------\n', '\n', '// ----------------------------------------------------------------------------\n', '// Safe maths\n', '// ----------------------------------------------------------------------------\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '}\n', '\n', 'library ExtendedMath {\n', '    //return the smaller of the two inputs (a or b)\n', '    function limitLessThan(uint a, uint b) internal pure returns (uint c) {\n', '        if(a > b) return b;\n', '        return a;\n', '    }\n', '}\n', '\n', 'contract ERC20Interface {\n', '\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC20 Token, with the addition of symbol, name and decimals and an\n', '// initial fixed supply\n', '// ----------------------------------------------------------------------------\n', 'contract _0xEtherToken is ERC20Interface {\n', '    using SafeMath for uint;\n', '    using ExtendedMath for uint;\n', '\n', '    string public symbol = "PoWEth";\n', '    string public name = "PoWEth Token";\n', '    uint8 public decimals = 8;\n', '    uint public _totalSupply = 10000000000000000;\n', '\tuint public maxSupplyForEra = 5000000000000000;\n', '\t\n', '    uint public latestDifficultyPeriodStarted;\n', '\tuint public tokensMinted;\n', '\t\n', "    uint public epochCount; //number of 'blocks' mined\n", '    uint public _BLOCKS_PER_READJUSTMENT = 1024;\n', '\n', '    uint public  _MINIMUM_TARGET = 2**16;\n', '    uint public  _MAXIMUM_TARGET = 2**234;\n', '\n', '    uint public miningTarget = _MAXIMUM_TARGET;\n', '\n', '    bytes32 public challengeNumber;   //generate a new one when a new reward is minted\n', '\n', '    uint public rewardEra;\n', '    \n', '    address public lastRewardTo;\n', '    uint public lastRewardAmount;\n', '    uint public lastRewardEthBlockNumber;\n', '\n', '    mapping(bytes32 => bytes32) solutionForChallenge;\n', '\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '    \n', '    address private owner;\n', '\n', '    event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);\n', '\n', '    function _0xEtherToken() public {\n', '        \n', '        owner = msg.sender;\n', '        \n', '        latestDifficultyPeriodStarted = block.number;\n', '\n', '        _startNewMiningEpoch();\n', '\n', '        //The owner gets nothing! You must mine this ERC20 token\n', '        //balances[owner] = _totalSupply;\n', '        //Transfer(address(0), owner, _totalSupply);\n', '    }\n', '\n', '\tfunction mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success) {\n', '\n', "\t\t//the PoW must contain work that includes a recent ethereum block hash (challenge number) and the msg.sender's address to prevent MITM attacks\n", '\t\tbytes32 digest = keccak256(challengeNumber, msg.sender, nonce );\n', '\n', '\t\t//the challenge digest must match the expected\n', '\t\tif (digest != challenge_digest) revert();\n', '\n', '\t\t//the digest must be smaller than the target\n', '\t\tif(uint256(digest) > miningTarget) revert();\n', '\n', '\t\t//only allow one reward for each challenge\n', '\t\tbytes32 solution = solutionForChallenge[challengeNumber];\n', '\t\tsolutionForChallenge[challengeNumber] = digest;\n', '\t\tif(solution != 0x0) \n', '\t\t\trevert();  //prevent the same answer from awarding twice\n', '\n', '\t\tuint reward_amount = getMiningReward();\n', '\n', '\t\tbalances[msg.sender] = balances[msg.sender].add(reward_amount);\n', '\n', '\t\ttokensMinted = tokensMinted.add(reward_amount);\n', '\n', '\t\t//Cannot mint more tokens than there are\n', '\t\tassert(tokensMinted <= maxSupplyForEra);\n', '\n', '\t\t//set readonly diagnostics data\n', '\t\tlastRewardTo = msg.sender;\n', '\t\tlastRewardAmount = reward_amount;\n', '\t\tlastRewardEthBlockNumber = block.number;\n', '\t\t\n', '\t\t_startNewMiningEpoch();\n', '    \temit Mint(msg.sender, reward_amount, epochCount, challengeNumber );\n', '\n', '\t   return true;\n', '\t}\n', '\n', "    //a new 'block' to be mined\n", '    function _startNewMiningEpoch() internal {\n', '\t\t//if max supply for the era will be exceeded next reward round then enter the new era before that happens\n', '\n', '\t\t//20 is the final reward era, almost all tokens minted\n', '\t\t//once the final era is reached, more tokens will not be given out because the assert function\n', '\t\t// 1 era is estimated 1,5y, 20 era is roughly 60y of mining time\n', '\t\tif( tokensMinted.add(getMiningReward()) > maxSupplyForEra && rewardEra < 19)\n', '\t\t{\n', '\t\t\trewardEra = rewardEra + 1;\n', '\t\t}\n', '\n', '\t\tmaxSupplyForEra = _totalSupply - _totalSupply / (2**(rewardEra + 1));\n', '\n', '\t\tepochCount = epochCount.add(1);\n', '\n', '\t\t//every so often, readjust difficulty. Dont readjust when deploying\n', '\t\tif(epochCount % _BLOCKS_PER_READJUSTMENT == 0)\n', '\t\t{\n', '\t\t\t_reAdjustDifficulty();\n', '\t\t}\n', '\n', '\t\t//make the latest ethereum block hash a part of the next challenge for PoW to prevent pre-mining future blocks\n', '\t\t//do this last since this is a protection mechanism in the mint() function\n', '\t\tchallengeNumber = block.blockhash(block.number - 1);\n', '    }\n', '\n', '    //https://en.bitcoin.it/wiki/Difficulty#What_is_the_formula_for_difficulty.3F\n', '    //as of 2017 the bitcoin difficulty was up to 17 zeroes, it was only 8 in the early days\n', '    //readjust the target by 5 percent\n', '    function _reAdjustDifficulty() internal {\n', '        uint ethBlocksSinceLastDifficultyPeriod = block.number - latestDifficultyPeriodStarted;\n', '        \n', '        //assume 240 ethereum blocks per hour\n', "        //we want miners to spend ~7,5 minutes to mine each 'block', about 30 ethereum blocks = 1 PoWEth epoch\n", '        uint targetEthBlocksPerDiffPeriod = _BLOCKS_PER_READJUSTMENT * 30; //should be 30 times slower than ethereum\n', '\n', '        //if there were less eth blocks passed in time than expected\n', '        if(ethBlocksSinceLastDifficultyPeriod < targetEthBlocksPerDiffPeriod)\n', '        {\n', '\t\t\tuint excess_block_pct = (targetEthBlocksPerDiffPeriod.mul(100)) / ethBlocksSinceLastDifficultyPeriod;\n', '\t\t\tuint excess_block_pct_extra = excess_block_pct.sub(100).limitLessThan(1000);\n', '\t\t\t\n', '\t\t\t//make it harder\n', '\t\t\tminingTarget = miningTarget.sub((miningTarget/2000).mul(excess_block_pct_extra));\n', '        }else{\n', '\t\t\tuint shortage_block_pct = (ethBlocksSinceLastDifficultyPeriod.mul(100)) / targetEthBlocksPerDiffPeriod;\n', '\t\t\tuint shortage_block_pct_extra = shortage_block_pct.sub(100).limitLessThan(1000);\n', '\n', '\t\t\t//make it easier\n', '\t\t\tminingTarget = miningTarget.add((miningTarget/2000).mul(shortage_block_pct_extra));\n', '        }\n', '\n', '        latestDifficultyPeriodStarted = block.number;\n', '\n', '        if(miningTarget < _MINIMUM_TARGET) //very difficult\n', '        {\n', '\t\t\tminingTarget = _MINIMUM_TARGET;\n', '        }\n', '\n', '        if(miningTarget > _MAXIMUM_TARGET) //very easy\n', '        {\n', '\t\t\tminingTarget = _MAXIMUM_TARGET;\n', '        }\n', '    }\n', '\n', '    //this is a recent ethereum block hash, used to prevent pre-mining future blocks\n', '    function getChallengeNumber() public constant returns (bytes32) {\n', '        return challengeNumber;\n', '    }\n', '\n', '    //the number of zeroes the digest of the PoW solution requires.  Auto adjusts\n', '     function getMiningDifficulty() public constant returns (uint) {\n', '        return _MAXIMUM_TARGET / miningTarget;\n', '    }\n', '\n', '    function getMiningTarget() public constant returns (uint) {\n', '       return miningTarget;\n', '\t}\n', '\n', '    //100m coins total\n', '    //reward begins at 250 and is cut in half every reward era (as tokens are mined)\n', '    function getMiningReward() public constant returns (uint) {\n', '\t\treturn 25000000000/(2**rewardEra);\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Total supply\n', '    // ------------------------------------------------------------------------\n', '    function totalSupply() public constant returns (uint) {\n', '        return _totalSupply  - balances[address(0)];\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account `tokenOwner`\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', "    // Transfer the balance from token owner's account to `to` account\n", "    // - Owner's account must have sufficient balance to transfer\n", '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', "    // from the token owner's account\n", '    //\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '    // recommends that there are no checks for the approval double-spend attack\n', '    // as this should be implemented in user interfaces\n', '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '    //\n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the `from` account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '        balances[from] = balances[from].sub(tokens);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', "    // transferred to the spender's account\n", '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', "    // from the token owner's account. The `spender` contract function\n", '    // `receiveApproval(...)` is then executed\n', '    // ------------------------------------------------------------------------\n', '    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', "    // Don't accept ETH\n", '    // ------------------------------------------------------------------------\n', '    function () public payable {\n', '        revert();\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Owner can transfer out any accidentally sent ERC20 tokens\n', '    // ------------------------------------------------------------------------\n', '    function transferAnyERC20Token(address tokenAddress, uint tokens) public returns (bool success) {\n', '        require(msg.sender == owner);\n', '        return ERC20Interface(tokenAddress).transfer(owner, tokens);\n', '    }\n', '    \n', '    //help debug mining software\n', '    function getMintDigest(uint256 nonce, bytes32 challenge_number) public view returns (bytes32 digesttest) {\n', '        bytes32 digest = keccak256(challenge_number,msg.sender,nonce);\n', '        return digest;\n', '\t}\n', '\n', '\t//help debug mining software\n', '\tfunction checkMintSolution(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number, uint testTarget) public view returns (bool success) {\n', '\t\tbytes32 digest = keccak256(challenge_number,msg.sender,nonce);\n', '\t\tif(uint256(digest) > testTarget) \n', '\t\t\trevert();\n', '\t\treturn (digest == challenge_digest);\n', '\t}\n', '}']