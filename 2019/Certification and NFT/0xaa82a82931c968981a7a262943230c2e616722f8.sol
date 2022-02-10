['/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner, "Sender not authorised.");\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', '    @title ItMap, a solidity iterable map\n', '    @dev Credit to: https://gist.github.com/ethers/7e6d443818cbc9ad2c38efa7c0f363d1\n', ' */\n', 'library itmap {\n', '    struct entry {\n', '        // Equal to the index of the key of this item in keys, plus 1.\n', '        uint keyIndex;\n', '        uint value;\n', '    }\n', '\n', '    struct itmap {\n', '        mapping(uint => entry) data;\n', '        uint[] keys;\n', '    }\n', '    \n', '    function insert(itmap storage self, uint key, uint value) internal returns (bool replaced) {\n', '        entry storage e = self.data[key];\n', '        e.value = value;\n', '        if (e.keyIndex > 0) {\n', '            return true;\n', '        } else {\n', '            e.keyIndex = ++self.keys.length;\n', '            self.keys[e.keyIndex - 1] = key;\n', '            return false;\n', '        }\n', '    }\n', '    \n', '    function remove(itmap storage self, uint key) internal returns (bool success) {\n', '        entry storage e = self.data[key];\n', '\n', '        if (e.keyIndex == 0) {\n', '            return false;\n', '        }\n', '\n', '        if (e.keyIndex < self.keys.length) {\n', '            // Move an existing element into the vacated key slot.\n', '            self.data[self.keys[self.keys.length - 1]].keyIndex = e.keyIndex;\n', '            self.keys[e.keyIndex - 1] = self.keys[self.keys.length - 1];\n', '        }\n', '\n', '        self.keys.length -= 1;\n', '        delete self.data[key];\n', '        return true;\n', '    }\n', '    \n', '    function contains(itmap storage self, uint key) internal constant returns (bool exists) {\n', '        return self.data[key].keyIndex > 0;\n', '    }\n', '    \n', '    function size(itmap storage self) internal constant returns (uint) {\n', '        return self.keys.length;\n', '    }\n', '    \n', '    function get(itmap storage self, uint key) internal constant returns (uint) {\n', '        return self.data[key].value;\n', '    }\n', '    \n', '    function getKey(itmap storage self, uint idx) internal constant returns (uint) {\n', '        return self.keys[idx];\n', '    }\n', '}\n', '\n', '/**\n', '    @title OwnersReceiver\n', '    @dev PoolOwners supporting receiving contract\n', ' */\n', 'contract OwnersReceiver {\n', '    function onOwnershipTransfer(address _sender, uint _value, bytes _data) public;\n', '    function onOwnershipStake(address _sender, uint _value, bytes _data) public;\n', '    function onOwnershipStakeRemoval(address _sender, uint _value, bytes _data) public;\n', '}\n', '\n', '/**\n', '    @title PoolOwners\n', '    @dev ERC20 token distribution to holders based on share ownership\n', ' */\n', 'contract PoolOwners is Ownable {\n', '\n', '    using SafeMath for uint256;\n', '    using itmap for itmap.itmap;\n', '\n', '    itmap.itmap private ownerMap;\n', '\n', '    mapping(address => mapping(address => uint256)) public allowance;\n', '    mapping(address => mapping(address => uint256)) public stakes;\n', '    mapping(address => uint256) public stakeTotals;\n', '    mapping(address => bool) public tokenWhitelist;\n', '    mapping(address => bool) public whitelist;\n', '    mapping(address => uint256) public distributionMinimum;\n', '    \n', '    uint256 public totalContributed = 0;\n', '    uint256 public precisionMinimum = 0.04 ether;\n', '    uint256 private valuation = 4000 ether;\n', '    uint256 private hardCap = 1000 ether;\n', '    uint256 private distribution = 1;\n', '    \n', '    bool public distributionActive = false;\n', '    bool public locked = false;\n', '    bool private contributionStarted = false;\n', '\n', '    address public wallet;\n', '    address private dToken = address(0);\n', '    \n', '    uint   public constant totalSupply = 4000 ether;\n', '    string public constant name = "LinkPool Owners";\n', '    uint8  public constant decimals = 18;\n', '    string public constant symbol = "LP";\n', '\n', '    event Contribution(address indexed sender, uint256 share, uint256 amount);\n', '    event TokenDistributionActive(address indexed token, uint256 amount, uint256 amountOfOwners);\n', '    event TokenWithdrawal(address indexed token, address indexed owner, uint256 amount);\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner, uint256 amount);\n', '    event TokenDistributionComplete(address indexed token, uint amount, uint256 amountOfOwners);\n', '    event OwnershipStaked(address indexed owner, address indexed receiver, uint256 amount);\n', '    event OwnershipStakeRemoved(address indexed owner, address indexed receiver, uint256 amount);\n', '\n', '    modifier onlyPoolOwner() {\n', '        require(ownerMap.get(uint(msg.sender)) != 0, "You are not authorised to call this function");\n', '        _;\n', '    }\n', '\n', '    modifier withinPrecision(uint256 _amount) {\n', '        require(_amount > 0, "Cannot use zero");\n', '        require(_amount % precisionMinimum == 0, "Your amount isn\'t divisible by the minimum precision amount");\n', '        _;\n', '    }\n', '\n', '    /**\n', '        @dev Constructor set set the wallet initally\n', '        @param _wallet Address of the ETH wallet\n', '     */\n', '    constructor(address _wallet) public {\n', '        require(_wallet != address(0), "The ETH wallet address needs to be set");\n', '        wallet = _wallet;\n', '        tokenWhitelist[address(0)] = true; // 0x0 treated as ETH\n', '    }\n', '\n', '    /**\n', '        @dev Fallback function, redirects to contribution\n', '        @dev Transfers tokens to the wallet address\n', '     */\n', '    function() public payable {\n', '        if (!locked) {\n', '            require(contributionStarted, "Contribution is not active");\n', '            require(whitelist[msg.sender], "You are not whitelisted");\n', '            contribute(msg.sender, msg.value); \n', '            wallet.transfer(msg.value);\n', '        }\n', '    }\n', '\n', '    /**\n', '        @dev Manually set a contribution, used by owners to increase owners amounts\n', '        @param _sender The address of the sender to set the contribution for you\n', '        @param _value The amount that the owner has sent\n', '     */\n', '    function addContribution(address _sender, uint256 _value) public onlyOwner() { contribute(_sender, _value); }\n', '\n', '    /**\n', '        @dev Registers a new contribution, sets their share\n', '        @param _sender The address of the wallet contributing\n', '        @param _value The amount that the owner has sent\n', '     */\n', '    function contribute(address _sender, uint256 _value) private withinPrecision(_value) {\n', '        require(_is128Bit(_value), "Contribution amount isn\'t 128bit or smaller");\n', '        require(!locked, "Crowdsale period over, contribution is locked");\n', '        require(!distributionActive, "Cannot contribute when distribution is active");\n', '        require(_value >= precisionMinimum, "Amount needs to be above the minimum contribution");\n', '        require(hardCap >= _value, "Your contribution is greater than the hard cap");\n', '        require(hardCap >= totalContributed.add(_value), "Your contribution would cause the total to exceed the hardcap");\n', '\n', '        totalContributed = totalContributed.add(_value);\n', '        uint256 share = percent(_value, valuation, 5);\n', '\n', '        uint owner = ownerMap.get(uint(_sender));\n', '        if (owner != 0) { // Existing owner\n', '            share += owner >> 128;\n', '            uint value = (owner << 128 >> 128).add(_value);\n', '            require(ownerMap.insert(uint(_sender), share << 128 | value), "Sender does not exist in the map");\n', '        } else { // New owner\n', '            require(!ownerMap.insert(uint(_sender), share << 128 | _value), "Map replacement detected");\n', '        }\n', '\n', '        emit Contribution(_sender, share, _value);\n', '    }\n', '\n', '    /**\n', '        @dev Whitelist a wallet address\n', '        @param _owner Wallet of the owner\n', '     */\n', '    function whitelistWallet(address _owner) external onlyOwner() {\n', '        require(!locked, "Can\'t whitelist when the contract is locked");\n', '        require(_owner != address(0), "Blackhole address");\n', '        whitelist[_owner] = true;\n', '    }\n', '\n', '    /**\n', '        @dev Start the distribution phase\n', '     */\n', '    function startContribution() external onlyOwner() {\n', '        require(!contributionStarted, "Contribution has started");\n', '        contributionStarted = true;\n', '    }\n', '\n', '    /**\n', '        @dev Manually set a share directly, used to set the LinkPool members as owners\n', '        @param _owner Wallet address of the owner\n', '        @param _value The equivalent contribution value\n', '     */\n', '    function setOwnerShare(address _owner, uint256 _value) public onlyOwner() withinPrecision(_value) {\n', '        require(!locked, "Can\'t manually set shares, it\'s locked");\n', '        require(!distributionActive, "Cannot set owners share when distribution is active");\n', '        require(_is128Bit(_value), "Contribution value isn\'t 128bit or smaller");\n', '\n', '        uint owner = ownerMap.get(uint(_owner));\n', '        uint share;\n', '        if (owner == 0) {\n', '            share = percent(_value, valuation, 5);\n', '            require(!ownerMap.insert(uint(_owner), share << 128 | _value), "Map replacement detected");\n', '        } else {\n', '            share = (owner >> 128).add(percent(_value, valuation, 5));\n', '            uint value = (owner << 128 >> 128).add(_value);\n', '            require(ownerMap.insert(uint(_owner), share << 128 | value), "Sender does not exist in the map");\n', '        }\n', '    }\n', '\n', '    /**\n', '        @dev Transfer part or all of your ownership to another address\n', "        @param _receiver The address that you're sending to\n", '        @param _amount The amount of ownership to send, for your balance refer to `ownerShareTokens`\n', '     */\n', '    function sendOwnership(address _receiver, uint256 _amount) public onlyPoolOwner() {\n', '        _sendOwnership(msg.sender, _receiver, _amount);\n', '    }\n', '\n', '    /**\n', '        @dev Transfer part or all of your ownership to another address and call the receiving contract\n', "        @param _receiver The address that you're sending to\n", '        @param _amount The amount of ownership to send, for your balance refer to `ownerShareTokens`\n', '     */\n', '    function sendOwnershipAndCall(address _receiver, uint256 _amount, bytes _data) public onlyPoolOwner() {\n', '        _sendOwnership(msg.sender, _receiver, _amount);\n', '        if (_isContract(_receiver)) {\n', '            OwnersReceiver(_receiver).onOwnershipTransfer(msg.sender, _amount, _data);\n', '        }\n', '    }\n', '\n', '    /**\n', '        @dev Transfer part or all of your ownership to another address on behalf of an owner\n', "        @dev Same principle as approval in ERC20, to be used mostly by external contracts, eg DEX's\n", "        @param _owner The address of the owner who's having tokens sent on behalf of\n", "        @param _receiver The address that you're sending to\n", '        @param _amount The amount of ownership to send, for your balance refer to `ownerShareTokens`\n', '     */\n', '    function sendOwnershipFrom(address _owner, address _receiver, uint256 _amount) public {\n', '        require(allowance[_owner][msg.sender] >= _amount, "Sender is not approved to send ownership of that amount");\n', '        allowance[_owner][msg.sender] = allowance[_owner][msg.sender].sub(_amount);\n', '        if (allowance[_owner][msg.sender] == 0) {\n', '            delete allowance[_owner][msg.sender];\n', '        }\n', '        _sendOwnership(_owner, _receiver, _amount);\n', '    }\n', '\n', '    /**\n', '        @dev Increase the allowance of a sender\n', '        @param _sender The address of the sender on behalf of the owner\n', '        @param _amount The amount to increase approval by\n', '     */\n', '    function increaseAllowance(address _sender, uint256 _amount) public withinPrecision(_amount) {\n', '        uint o = ownerMap.get(uint(msg.sender));\n', '        require(o << 128 >> 128 >= _amount, "The amount to increase allowance by is higher than your balance");\n', '        allowance[msg.sender][_sender] = allowance[msg.sender][_sender].add(_amount);\n', '    }\n', '\n', '    /**\n', '        @dev Decrease the allowance of a sender\n', '        @param _sender The address of the sender on behalf of the owner\n', '        @param _amount The amount to decrease approval by\n', '     */\n', '    function decreaseAllowance(address _sender, uint256 _amount) public withinPrecision(_amount) {\n', '        require(allowance[msg.sender][_sender] >= _amount, "The amount to decrease allowance by is higher than the current allowance");\n', '        allowance[msg.sender][_sender] = allowance[msg.sender][_sender].sub(_amount);\n', '        if (allowance[msg.sender][_sender] == 0) {\n', '            delete allowance[msg.sender][_sender];\n', '        }\n', '    }\n', '\n', '    /**\n', '        @dev Stakes ownership with a contract, locking it from being transferred\n', '        @dev Calls the `onOwnershipStake` implementation on the receiver\n', '        @param _receiver The contract address to receive the stake\n', '        @param _amount The amount to be staked\n', '        @param _data Subsequent data to be sent with the stake\n', '     */\n', '    function stakeOwnership(address _receiver, uint256 _amount, bytes _data) public withinPrecision(_amount) {\n', '        uint o = ownerMap.get(uint(msg.sender));\n', '        require((o << 128 >> 128).sub(stakeTotals[msg.sender]) >= _amount, "The amount to be staked is higher than your balance");\n', '        stakeTotals[msg.sender] = stakeTotals[msg.sender].add(_amount);\n', '        stakes[msg.sender][_receiver] = stakes[msg.sender][_receiver].add(_amount);\n', '        OwnersReceiver(_receiver).onOwnershipStake(msg.sender, _amount, _data);\n', '        emit OwnershipStaked(msg.sender, _receiver, _amount);\n', '    }\n', '\n', '    /**\n', '        @dev Removes an ownership stake\n', '        @dev Calls the `onOwnershipStakeRemoval` implementation on the receiver\n', '        @param _receiver The contract address to remove the stake\n', '        @param _amount The amount of the stake to be removed\n', '        @param _data Subsequent data to be sent with the stake\n', '     */\n', '    function removeOwnershipStake(address _receiver, uint256 _amount, bytes _data) public withinPrecision(_amount) {\n', '        require(stakeTotals[msg.sender] >= _amount, "The stake amount to remove is higher than what\'s staked");\n', '        require(stakes[msg.sender][_receiver] >= _amount, "The stake amount to remove is greater than what\'s staked with the receiver");\n', '        stakeTotals[msg.sender] = stakeTotals[msg.sender].sub(_amount);\n', '        stakes[msg.sender][_receiver] = stakes[msg.sender][_receiver].sub(_amount);\n', '        if (stakes[msg.sender][_receiver] == 0) {\n', '            delete stakes[msg.sender][_receiver];\n', '        }\n', '        if (stakeTotals[msg.sender] == 0) {\n', '            delete stakeTotals[msg.sender];\n', '        }\n', '        OwnersReceiver(_receiver).onOwnershipStakeRemoval(msg.sender, _amount, _data);\n', '        emit OwnershipStakeRemoved(msg.sender, _receiver, _amount);\n', '    }\n', '\n', '    /**\n', '        @dev Lock the contribution/shares methods\n', '     */\n', '    function finishContribution() public onlyOwner() {\n', '        require(!locked, "Shares already locked");\n', '        locked = true;\n', '    }\n', '\n', '    /**\n', '        @dev Start the distribution phase in the contract so owners can claim their tokens\n', '        @param _token The token address to start the distribution of\n', '     */\n', '    function distributeTokens(address _token) public onlyPoolOwner() {\n', '        require(tokenWhitelist[_token], "Token is not whitelisted to be distributed");\n', '        require(!distributionActive, "Distribution is already active");\n', '        distributionActive = true;\n', '\n', '        uint256 currentBalance;\n', '        if (_token == address(0)) {\n', '            currentBalance = address(this).balance;\n', '        } else {\n', '            currentBalance = ERC20(_token).balanceOf(this);\n', '        }\n', '        if (!_is128Bit(currentBalance)) {\n', '            currentBalance = 1 << 128;\n', '        }\n', '        require(currentBalance > distributionMinimum[_token], "Amount in the contract isn\'t above the minimum distribution limit");\n', '\n', '        distribution = currentBalance << 128;\n', '        dToken = _token;\n', '\n', '        emit TokenDistributionActive(_token, currentBalance, ownerMap.size());\n', '    }\n', '\n', '    /**\n', '        @dev Batch claiming of tokens for owners\n', '        @param _count The amount of owners to claim tokens for\n', '     */\n', '    function batchClaim(uint256 _count) public onlyPoolOwner() {\n', '        require(distributionActive, "Distribution isn\'t active");\n', '        uint claimed = distribution << 128 >> 128;\n', '        uint to = _count.add(claimed);\n', '        distribution = distribution >> 128 << 128 | to;\n', '        require(_count.add(claimed) <= ownerMap.size(), "To value is greater than the amount of owners");\n', '\n', '        if (to == ownerMap.size()) {\n', '            distributionActive = false;\n', '            emit TokenDistributionComplete(dToken, distribution >> 128, ownerMap.size());\n', '        }\n', '        for (uint256 i = claimed; i < to; i++) {\n', '            _claimTokens(i);\n', '        }\n', '    }\n', '\n', '    /**\n', '        @dev Whitelist a token so it can be distributed\n', '        @dev Token whitelist is due to the potential of minting tokens and constantly lock this contract in distribution\n', '     */\n', '    function whitelistToken(address _token, uint256 _minimum) public onlyOwner() {\n', '        require(!tokenWhitelist[_token], "Token is already whitelisted");\n', '        tokenWhitelist[_token] = true;\n', '        distributionMinimum[_token] = _minimum;\n', '    }\n', '\n', '    /**\n', '        @dev Set the minimum amount to be of transfered in this contract to start distribution\n', '        @param _minimum The minimum amount\n', '     */\n', '    function setDistributionMinimum(address _token, uint256 _minimum) public onlyOwner() {\n', '        distributionMinimum[_token] = _minimum;\n', '    }\n', '\n', '    /**\n', '        @dev ERC20 implementation of balances to allow for viewing in supported wallets\n', '        @param _owner The address of the owner\n', '     */\n', '    function balanceOf(address _owner) public view returns (uint) {\n', '        return ownerMap.get(uint(_owner)) << 128 >> 128;\n', '    }\n', '\n', '    /**\n', '        @dev Get the amount of unclaimed owners in a distribution cycle\n', '     */\n', '    function getClaimedOwners() public view returns (uint) {\n', '        return distribution << 128 >> 128;\n', '    }\n', '\n', '    /**\n', '        @dev Return an owners percentage\n', '        @param _owner The address of the owner\n', '     */\n', '    function getOwnerPercentage(address _owner) public view returns (uint) {\n', '        return ownerMap.get(uint(_owner)) >> 128;\n', '    }\n', '\n', '    /**\n', '        @dev Return an owners share token amount\n', '        @param _owner The address of the owner\n', '     */\n', '    function getOwnerTokens(address _owner) public view returns (uint) {\n', '        return ownerMap.get(uint(_owner)) << 128 >> 128;\n', '    }\n', '\n', '    /**\n', '        @dev Returns the current amount of active owners, ie share above 0\n', '     */\n', '    function getCurrentOwners() public view returns (uint) {\n', '        return ownerMap.size();\n', '    }\n', '\n', '    /**\n', '        @dev Returns owner address based on the key\n', '        @param _i The index of the owner in the map\n', '     */\n', '    function getOwnerAddress(uint _i) public view returns (address) {\n', '        require(_i < ownerMap.size(), "Index is greater than the map size");\n', '        return address(ownerMap.getKey(_i));\n', '    }\n', '\n', '    /**\n', '        @dev Returns the allowance amount for a sender address\n', '        @param _owner The address of the owner\n', '        @param _sender The address of the sender on an owners behalf\n', '     */\n', '    function getAllowance(address _owner, address _sender) public view returns (uint256) {\n', '        return allowance[_owner][_sender];\n', '    }\n', '\n', '    /**\n', '        @dev Credit to Rob Hitchens: https://stackoverflow.com/a/42739843\n', '     */\n', '    function percent(uint numerator, uint denominator, uint precision) private pure returns (uint quotient) {\n', '        uint _numerator = numerator * 10 ** (precision+1);\n', '        uint _quotient = ((_numerator / denominator) + 5) / 10;\n', '        return ( _quotient);\n', '    }\n', '\n', '    // Private Methods\n', '\n', '    /**\n', '        @dev Claim the tokens for the next owner in the map\n', '     */\n', '    function _claimTokens(uint _i) private {\n', '        address owner = address(ownerMap.getKey(_i));\n', '        uint o = ownerMap.get(uint(owner));\n', '        uint256 tokenAmount = (distribution >> 128).mul(o >> 128).div(100000);\n', '        if (dToken == address(0) && !_isContract(owner)) {\n', '            owner.transfer(tokenAmount);\n', '        } else {\n', '            require(ERC20(dToken).transfer(owner, tokenAmount), "ERC20 transfer failed");\n', '        }\n', '    }  \n', '\n', '    /**\n', '        @dev Transfers tokens to a different address\n', '        @dev Shared by all transfer implementations\n', '     */\n', '    function _sendOwnership(address _owner, address _receiver, uint256 _amount) private withinPrecision(_amount) {\n', '        uint o = ownerMap.get(uint(_owner));\n', '        uint r = ownerMap.get(uint(_receiver));\n', '\n', '        uint oTokens = o << 128 >> 128;\n', '        uint rTokens = r << 128 >> 128;\n', '\n', '        require(_is128Bit(_amount), "Amount isn\'t 128bit or smaller");\n', '        require(_owner != _receiver, "You can\'t send to yourself");\n', '        require(_receiver != address(0), "Ownership cannot be blackholed");\n', '        require(oTokens > 0, "You don\'t have any ownership");\n', '        require(oTokens.sub(stakeTotals[_owner]) >= _amount, "The amount to send exceeds the addresses balance");\n', '        require(!distributionActive, "Distribution cannot be active when sending ownership");\n', '        require(_amount % precisionMinimum == 0, "Your amount isn\'t divisible by the minimum precision amount");\n', '\n', '        oTokens = oTokens.sub(_amount);\n', '\n', '        if (oTokens == 0) {\n', '            require(ownerMap.remove(uint(_owner)), "Address doesn\'t exist in the map");\n', '        } else {\n', '            uint oPercentage = percent(oTokens, valuation, 5);\n', '            require(ownerMap.insert(uint(_owner), oPercentage << 128 | oTokens), "Sender does not exist in the map");\n', '        }\n', '        \n', '        uint rTNew = rTokens.add(_amount);\n', '        uint rPercentage = percent(rTNew, valuation, 5);\n', '        if (rTokens == 0) {\n', '            require(!ownerMap.insert(uint(_receiver), rPercentage << 128 | rTNew), "Map replacement detected");\n', '        } else {\n', '            require(ownerMap.insert(uint(_receiver), rPercentage << 128 | rTNew), "Sender does not exist in the map");\n', '        }\n', '\n', '        emit OwnershipTransferred(_owner, _receiver, _amount);\n', '    }\n', '\n', '    /**\n', '        @dev Check whether an address given is a contract\n', '     */\n', '    function _isContract(address _addr) private view returns (bool hasCode) {\n', '        uint length;\n', '        assembly { length := extcodesize(_addr) }\n', '        return length > 0;\n', '    }\n', '\n', '    /**\n', '        @dev Strict type check for data packing\n', '        @param _val The value for checking\n', '     */\n', '    function _is128Bit(uint _val) private pure returns (bool) {\n', '        return _val < 1 << 128;\n', '    }\n', '}']