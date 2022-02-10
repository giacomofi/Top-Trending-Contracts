['pragma solidity ^0.4.8;\n', '\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' * By OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/contracts/SafeMath.sol\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ContractReceiver {\n', '    function tokenFallback(address _from, uint256 _value, bytes  _data) external;\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '    address public ownerCandidate;\n', '    event OwnerTransfer(address originalOwner, address currentOwner);\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function proposeNewOwner(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0) && newOwner != owner);\n', '        ownerCandidate = newOwner;\n', '    }\n', '\n', '    function acceptOwnerTransfer() public {\n', '        require(msg.sender == ownerCandidate);\n', '        OwnerTransfer(owner, ownerCandidate);\n', '        owner = ownerCandidate;\n', '    }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   */\n', '  function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '\n', '// Based in part on code by Open-Zeppelin: https://github.com/OpenZeppelin/zeppelin-solidity.git\n', '// Based in part on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', '// Smart contract for the RepuX token & the first crowdsale\n', 'contract RepuX is StandardToken, Ownable {\n', '    string public constant name = "RepuX";\n', '    string public constant symbol = "REPUX";\n', '    uint8 public constant decimals = 18;\n', '    address public multisig; //multisig wallet, to which all contributions will be sent\n', '\n', '    uint256 public phase1StartBlock; //Crowdsale start block\n', '    uint256 public phase1EndBlock; // Day 7 (estimate)\n', '    uint256 public phase2EndBlock; // Day 13 (estimate)\n', '    uint256 public phase3EndBlock; // Day 19 (estimate)\n', '    uint256 public phase4EndBlock; // Day 25 (estimate)\n', '    uint256 public phase5EndBlock; // Day 31 (estimate)\n', '    uint256 public endBlock; //whole crowdsale end block\n', '\n', '    uint256 public basePrice = 1818 * (10**11); // ICO token base price: ~$0.20 (estimate assuming $1100 per Eth)\n', '\n', '    uint256 public totalSupply = 500000000 * (10**uint256(decimals)); //Token total supply: 500000000 RPX\n', '    uint256 public presaleTokenSupply = totalSupply.mul(20).div(100); //Amount of tokens available during presale (10%)\n', '    uint256 public crowdsaleTokenSupply = totalSupply.mul(30).div(100); //Amount of tokens available during crowdsale (50%)\n', '    uint256 public rewardsTokenSupply = totalSupply.mul(15).div(100); //Rewards pool (VIP etc, 10%), ambassador share(3%) & ICO bounties(2%)\n', '    uint256 public teamTokenSupply = totalSupply.mul(12).div(100); //Tokens distributed to team (12% in total, 4% vested for 12, 24 & 36 months)\n', '    uint256 public platformTokenSupply = totalSupply.mul(23).div(100); //Token reserve for sale on platform\n', '    uint256 public presaleTokenSold = 0; //Records the amount of tokens sold during presale\n', '    uint256 public crowdsaleTokenSold = 0; //Records the amount of tokens sold during the crowdsale\n', '\n', '    uint256 public phase1Cap = crowdsaleTokenSupply.mul(50).div(100);\n', '    uint256 public phase2Cap = crowdsaleTokenSupply.mul(60).div(100);\n', '    uint256 public phase3Cap = crowdsaleTokenSupply.mul(70).div(100);\n', '    uint256 public phase4Cap = crowdsaleTokenSupply.mul(80).div(100);\n', '\n', '    uint256 public transferLockup = 5760; //Lock up token transfer until ~2 days after crowdsale concludes\n', '    uint256 public teamLockUp; \n', '    uint256 private teamWithdrawlCount = 0;\n', '    uint256 public averageBlockTime = 18; //Average block time in seconds\n', '\n', '    bool public presaleStarted = false;\n', '    bool public presaleConcluded = false;\n', '    bool public crowdsaleStarted = false;\n', '    bool public crowdsaleConcluded = false;\n', '    bool public ICOReserveWithdrawn = false;\n', '    bool public halted = false; //Halt crowdsale in emergency\n', '\n', '    uint256 contributionCount = 0;\n', '    bytes32[] public contributionHashes;\n', '    mapping (bytes32 => Contribution) private contributions;\n', '\n', '    address public teamWithdrawalRecipient = address(0);\n', '    bool public teamWithdrawalProposed = false;\n', '    bool teamWithdrawn = false;\n', '\n', '    event Halt(); //Halt event\n', '    event Unhalt(); //Unhalt event\n', '    event Burn(address burner, uint256 amount);\n', '    event StartPresale();\n', '    event ConcludePresale();\n', '    event StartCrowdsale();\n', '    event ConcludeCrowdsale();\n', '    event SetMultisig(address newMultisig);\n', '\n', '    struct Contribution {\n', '        address contributor;\n', '        address recipient;\n', '        uint256 ethWei;\n', '        uint256 tokens;\n', '        bool resolved;\n', '        bool success;\n', '        uint8 stage;\n', '    }\n', '\n', '    event ContributionReceived(bytes32 contributionHash, address contributor, address recipient,\n', '        uint256 ethWei, uint256 pendingTokens);\n', '\n', '    event ContributionResolved(bytes32 contributionHash, bool pass, address contributor, \n', '        address recipient, uint256 ethWei, uint256 tokens);\n', '\n', '\n', '    // lockup during and after 48h of end of crowdsale\n', '    modifier crowdsaleTransferLock() {\n', '        require(crowdsaleConcluded && block.number >= endBlock.add(transferLockup));\n', '        _;\n', '    }\n', '\n', '    modifier whenNotHalted() {\n', '        require(!halted);\n', '        _;\n', '    }\n', '\n', '    //Constructor: set owner (team) address & crowdsale recipient multisig wallet address\n', '    //Allocate reward tokens to the team wallet\n', '  \tfunction RepuX(address _multisig) {\n', '        owner = msg.sender;\n', '        multisig = _multisig;\n', '  \t}\n', '\n', '    //Fallback function when receiving Ether. Contributors can directly send Ether to the token address during crowdsale.\n', '    function() payable {\n', '        buy();\n', '    }\n', '\n', '\n', '    //Halt ICO in case of emergency.\n', '    function halt() public onlyOwner {\n', '        halted = true;\n', '        Halt();\n', '    }\n', '\n', '    function unhalt() public onlyOwner {\n', '        halted = false;\n', '        Unhalt();\n', '    }\n', '\n', '    function startPresale() public onlyOwner {\n', '        require(!presaleStarted);\n', '        presaleStarted = true;\n', '        StartPresale();\n', '    }\n', '\n', '    function concludePresale() public onlyOwner {\n', '        require(presaleStarted && !presaleConcluded);\n', '        presaleConcluded = true;\n', '        //Unsold tokens in the presale are made available in the crowdsale.\n', '        crowdsaleTokenSupply = crowdsaleTokenSupply.add(presaleTokenSupply.sub(presaleTokenSold)); \n', '        ConcludePresale();\n', '    }\n', '\n', '    //Can only be called after presale is concluded.\n', '    function startCrowdsale() public onlyOwner {\n', '        require(presaleConcluded && !crowdsaleStarted);\n', '        crowdsaleStarted = true;\n', '        phase1StartBlock = block.number;\n', '        phase1EndBlock = phase1StartBlock.add(dayToBlockNumber(7));\n', '        phase2EndBlock = phase1EndBlock.add(dayToBlockNumber(6));\n', '        phase3EndBlock = phase2EndBlock.add(dayToBlockNumber(6));\n', '        phase4EndBlock = phase3EndBlock.add(dayToBlockNumber(6));\n', '        phase5EndBlock = phase4EndBlock.add(dayToBlockNumber(6));\n', '        endBlock = phase5EndBlock;\n', '        StartCrowdsale();\n', '    }\n', '\n', '    //Can only be called either after crowdsale time period ends, or after tokens have sold out\n', '    function concludeCrowdsale() public onlyOwner {\n', '        require(crowdsaleStarted && !crowdsaleOn() && !crowdsaleConcluded);\n', '        crowdsaleConcluded = true;\n', '        endBlock = block.number;\n', '        uint256 unsold = crowdsaleTokenSupply.sub(crowdsaleTokenSold);\n', '        if (unsold > 0) {\n', '            //Burn unsold tokens\n', '            totalSupply = totalSupply.sub(unsold);\n', '            Burn(this, unsold);\n', '            Transfer(this, address(0), unsold);\n', '        }\n', '        teamLockUp = dayToBlockNumber(365); //12-month lock-up period\n', '        ConcludeCrowdsale();\n', '    }\n', '\n', '    function proposeTeamWithdrawal(address recipient) public onlyOwner {\n', '        require(!teamWithdrawn);\n', '        teamWithdrawalRecipient = recipient;\n', '        teamWithdrawalProposed = true;\n', '    }\n', '\n', '    function cancelTeamWithdrawal() public onlyOwner {\n', '        require(!teamWithdrawn);\n', '        require(teamWithdrawalProposed);\n', '        teamWithdrawalProposed = false;\n', '        teamWithdrawalRecipient = address(0); \n', '    }\n', '\n', '    function confirmTeamWithdrawal() public {\n', '        require(!teamWithdrawn);\n', '        require(teamWithdrawalProposed);\n', '        require(msg.sender == teamWithdrawalRecipient);\n', '        teamWithdrawn = true;\n', '        uint256 tokens = rewardsTokenSupply.add(teamTokenSupply).add(platformTokenSupply);\n', '        balances[msg.sender] = balances[msg.sender].add(tokens);\n', '        Transfer(this, msg.sender, tokens);\n', '    }\n', '\n', '\n', '    function buy() payable {\n', '        buyRecipient(msg.sender);\n', '    }\n', '\n', '\n', '    //Allow addresses to buy token for another account\n', '    function buyRecipient(address recipient) public payable whenNotHalted {\n', '        require(msg.value > 0);\n', '        require(presaleOn()||crowdsaleOn()); //Contribution only allowed during presale/crowdsale\n', '        uint256 tokens = msg.value.mul(10**uint256(decimals)).div(tokenPrice()); \n', '        uint8 stage = 0;\n', '\n', '        if(presaleOn()) {\n', '            require(presaleTokenSold.add(tokens) <= presaleTokenSupply);\n', '            presaleTokenSold = presaleTokenSold.add(tokens);\n', '        } else {\n', '            require(crowdsaleTokenSold.add(tokens) <= crowdsaleTokenSupply);\n', '            crowdsaleTokenSold = crowdsaleTokenSold.add(tokens);\n', '            stage = 1;\n', '        }\n', '        contributionCount = contributionCount.add(1);\n', '        bytes32 transactionHash = keccak256(contributionCount, msg.sender, msg.value, msg.data,\n', '            msg.gas, block.number, tx.gasprice);\n', '        contributions[transactionHash] = Contribution(msg.sender, recipient, msg.value, \n', '            tokens, false, false, stage);\n', '        contributionHashes.push(transactionHash);\n', '        ContributionReceived(transactionHash, msg.sender, recipient, msg.value, tokens);\n', '    }\n', '\n', '    //Accept a contribution if KYC passed.\n', '    function acceptContribution(bytes32 transactionHash) public onlyOwner {\n', '        Contribution storage c = contributions[transactionHash];\n', '        require(!c.resolved);\n', '        c.resolved = true;\n', '        c.success = true;\n', '        balances[c.recipient] = balances[c.recipient].add(c.tokens);\n', '        assert(multisig.send(c.ethWei));\n', '        Transfer(this, c.recipient, c.tokens);\n', '        ContributionResolved(transactionHash, true, c.contributor, c.recipient, c.ethWei, \n', '            c.tokens);\n', '    }\n', '\n', '    //Reject a contribution if KYC failed.\n', '    function rejectContribution(bytes32 transactionHash) public onlyOwner {\n', '        Contribution storage c = contributions[transactionHash];\n', '        require(!c.resolved);\n', '        c.resolved = true;\n', '        c.success = false;\n', '        if (c.stage == 0) {\n', '            presaleTokenSold = presaleTokenSold.sub(c.tokens);\n', '        } else {\n', '            crowdsaleTokenSold = crowdsaleTokenSold.sub(c.tokens);\n', '        }\n', '        assert(c.contributor.send(c.ethWei));\n', '        ContributionResolved(transactionHash, false, c.contributor, c.recipient, c.ethWei, \n', '            c.tokens);\n', '    }\n', '\n', '    // Team manually mints tokens in case of BTC/wire-transfer contributions\n', '    function mint(address recipient, uint256 value) public onlyOwner {\n', '    \trequire(value > 0);\n', '    \trequire(presaleOn()||crowdsaleOn()); //Minting only allowed during presale/crowdsale\n', '    \tif(presaleOn()) {\n', '            require(presaleTokenSold.add(value) <= presaleTokenSupply);\n', '            presaleTokenSold = presaleTokenSold.add(value);\n', '        } else {\n', '            require(crowdsaleTokenSold.add(value) <= crowdsaleTokenSupply);\n', '            crowdsaleTokenSold = crowdsaleTokenSold.add(value);\n', '        }\n', '        balances[recipient] = balances[recipient].add(value);\n', '        Transfer(this, recipient, value);\n', '    }\n', '\n', '\n', '    //Burns the specified amount of tokens from the team wallet address\n', '    function burn(uint256 _value) public onlyOwner returns (bool) {\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        Transfer(msg.sender, address(0), _value);\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    //Allow team to change the recipient multisig address\n', '    function setMultisig(address addr) public onlyOwner {\n', '      \trequire(addr != address(0));\n', '      \tmultisig = addr;\n', '        SetMultisig(addr);\n', '    }\n', '\n', '    //Allows Team to adjust average blocktime according to network status, \n', '    //in order to provide more precise timing for ICO phases & lock-up periods\n', '    function setAverageBlockTime(uint256 newBlockTime) public onlyOwner {\n', '        require(newBlockTime > 0);\n', '        averageBlockTime = newBlockTime;\n', '    }\n', '\n', '    //Allows Team to adjust basePrice so price of the token has correct correlation to dollar\n', '    function setBasePrice(uint256 newBasePrice) public onlyOwner {\n', '        require(newBasePrice > 0);\n', '        basePrice = newBasePrice;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public crowdsaleTransferLock \n', '    returns(bool) {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public \n', '    crowdsaleTransferLock returns(bool) {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    //Price of token in terms of ether.\n', '    function tokenPrice() public constant returns(uint256) {\n', '        uint8 p = phase();\n', '        if (p == 0) return basePrice.mul(50).div(100); //Presale: 50% discount\n', '        if (p == 1) return basePrice.mul(70).div(100); //ICO phase 1: 30% discount\n', '        if (p == 2) return basePrice.mul(75).div(100); //Phase 2 :25% discount\n', '        if (p == 3) return basePrice.mul(80).div(100); //Phase 3: 20% discount\n', '        if (p == 4) return basePrice.mul(85).div(100); //Phase 4: 15% discount\n', '        if (p == 5) return basePrice.mul(90).div(100); //Phase 5: 10% discount\n', '        return basePrice;\n', '    }\n', '\n', '    function phase() public constant returns (uint8) {\n', '        if (presaleOn()) return 0;\n', '        if (crowdsaleTokenSold <= phase1Cap && block.number <= phase1EndBlock) return 1;\n', '        if (crowdsaleTokenSold <= phase2Cap && block.number <= phase2EndBlock) return 2;\n', '        if (crowdsaleTokenSold <= phase3Cap && block.number <= phase3EndBlock) return 3;\n', '        if (crowdsaleTokenSold <= phase4Cap && block.number <= phase4EndBlock) return 4;\n', '        if (crowdsaleTokenSold <= crowdsaleTokenSupply && block.number <= phase5EndBlock) return 5;\n', '        return 6;\n', '    }\n', '\n', '    function presaleOn() public constant returns (bool) {\n', '        return (presaleStarted && !presaleConcluded && presaleTokenSold < presaleTokenSupply);\n', '    }\n', '\n', '    function crowdsaleOn() public constant returns (bool) {\n', '        return (crowdsaleStarted && block.number <= endBlock && crowdsaleTokenSold < crowdsaleTokenSupply);\n', '    }\n', '\n', '    function dayToBlockNumber(uint256 dayNum) public constant returns(uint256) {\n', '        return dayNum.mul(86400).div(averageBlockTime); //86400 = 24*60*60 = number of seconds in a day\n', '    }\n', '\n', '    function getContributionFromHash(bytes32 contributionHash) public constant returns (\n', '            address contributor,\n', '            address recipient,\n', '            uint256 ethWei,\n', '            uint256 tokens,\n', '            bool resolved,\n', '            bool success\n', '        ) {\n', '        Contribution c = contributions[contributionHash];\n', '        contributor = c.contributor;\n', '        recipient = c.recipient;\n', '        ethWei = c.ethWei;\n', '        tokens = c.tokens;\n', '        resolved = c.resolved;\n', '        success = c.success;\n', '    }\n', '\n', '    function getContributionHashes() public constant returns (bytes32[]) {\n', '        return contributionHashes;\n', '    }\n', '\n', '}']