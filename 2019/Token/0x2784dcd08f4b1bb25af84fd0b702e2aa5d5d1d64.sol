['pragma solidity ^0.5.8;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath \n', '{\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) \n', '    {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) \n', '    {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) \n', '    {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) \n', '    {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable \n', '{\n', '    address public owner;\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor() public\n', '    {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() \n', '    {\n', '        assert(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) onlyOwner public\n', '    {\n', '        assert(newOwner != address(0));\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic \n', '{\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic \n', '{\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title POS\n', ' * @dev the interface of Proof-Of-Stake\n', ' */\n', 'contract POS \n', '{\n', '    uint256 public stakeStartTime;\n', '    uint256 public stakeMinAge;\n', '    uint256 public stakeMaxAge;\n', '    function pos() public returns (bool);\n', '    function coinAge() public view returns (uint);\n', '    function annualPos() public view returns (uint256);\n', '    event Mint(address indexed _address, uint _reward);\n', '}\n', '\n', 'contract CraftR is ERC20,POS,Ownable \n', '{\n', '    using SafeMath for uint256;\n', '\n', '    string public name = "CraftR";\n', '    string public symbol = "CRAFTR";\n', '    uint public decimals = 18;\n', '\n', '    uint public chainStartTime; \n', '    uint public chainStartBlockNumber;\n', '    uint public stakeStartTime;\n', '    uint public stakeMinAge = 1 days;\n', '    uint public stakeMaxAge = 90 days;\n', '    uint public defaultPOS = 10**17; // default 10% annual interest\n', '\n', '    uint public totalSupply;\n', '    uint public maxTotalSupply;\n', '    uint public totalInitialSupply;\n', '\n', '    struct transferInStruct\n', '    {\n', '        uint128 amount;\n', '        uint64 time;\n', '    }\n', '\n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping (address => uint256)) allowed;\n', '    mapping(address => transferInStruct[]) txIns;\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    /**\n', '     * @dev Fix for the ERC20 short address attack.\n', '     */\n', '    modifier onlyPayloadSize(uint size) \n', '    {\n', '        assert(msg.data.length >= size + 4);\n', '        _;\n', '    }\n', '\n', '    modifier canRunPos() \n', '    {\n', '        assert(totalSupply < maxTotalSupply);\n', '        _;\n', '    }\n', '\n', '    constructor () public \n', '    {\n', '        maxTotalSupply = 100*10**24; // 100 Mil\n', '        totalInitialSupply = 60*10**24; // 60 Mil\n', '\n', '        chainStartTime = now;\n', '        chainStartBlockNumber = block.number;\n', '        stakeStartTime = now;\n', '\n', '        balances[msg.sender] = totalInitialSupply;\n', '        totalSupply = totalInitialSupply;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool) \n', '    {\n', '        if(msg.sender == _to) return pos();\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        if(txIns[msg.sender].length > 0) delete txIns[msg.sender];\n', '        uint64 _now = uint64(now);\n', '        txIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));\n', '        txIns[_to].push(transferInStruct(uint128(_value),_now));\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance) \n', '    {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) public returns (bool) \n', '    {\n', '        require(_to != address(0));\n', '\n', '        uint256 _allowance = allowed[_from][msg.sender];\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = _allowance.sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        if(txIns[_from].length > 0) delete txIns[_from];\n', '        uint64 _now = uint64(now);\n', '        txIns[_from].push(transferInStruct(uint128(balances[_from]),_now));\n', '        txIns[_to].push(transferInStruct(uint128(_value),_now));\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) \n', '    {\n', '        require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) \n', '    {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function pos() canRunPos public returns (bool) \n', '    {\n', '        if(balances[msg.sender] <= 0) return false;\n', '        if(txIns[msg.sender].length <= 0) return false;\n', '\n', '        uint reward = getPosReward(msg.sender);\n', '        if(reward <= 0) return false;\n', '\n', '        totalSupply = totalSupply.add(reward);\n', '        balances[msg.sender] = balances[msg.sender].add(reward);\n', '        delete txIns[msg.sender];\n', '        txIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));\n', '\n', '        emit Mint(msg.sender, reward);\n', '        return true;\n', '    }\n', '\n', '    function getCraftrBlockNumber() public view returns (uint blockNumber) \n', '    {\n', '        blockNumber = block.number.sub(chainStartBlockNumber);\n', '    }\n', '\n', '    function coinAge() public view returns (uint myCoinAge) \n', '    {\n', '        myCoinAge = getCoinAge(msg.sender,now);\n', '    }\n', '\n', '    function annualPos() public view returns(uint interest) \n', '    {\n', '        uint _now = now;\n', '        interest = defaultPOS;\n', '        if((_now.sub(stakeStartTime)).div(365 days) == 0)\n', '        {\n', '            interest = (435 * defaultPOS).div(100);\n', '        }\n', '    }\n', '\n', '    function getPosReward(address _address) internal view returns (uint) \n', '    {\n', '        require( (now >= stakeStartTime) && (stakeStartTime > 0) );\n', '\n', '        uint _now = now;\n', '        uint _coinAge = getCoinAge(_address, _now);\n', '        if(_coinAge <= 0) return 0;\n', '\n', '        uint interest = defaultPOS;\n', '        // Due to the high interest rate for the first two years, compounding should be taken into account.\n', '        // Effective annual interest rate = (1 + (nominal rate / number of compounding periods)) ^ (number of compounding periods) - 1\n', '        if((_now.sub(stakeStartTime)).div(365 days) == 0) \n', '        {\n', '            // 2nd year effective annual interest rate is 50% when we select the stakeMaxAge (90 days) as the compounding period.\n', '            // 1st year has already been calculated through the old contract\n', '            interest = (435 * defaultPOS).div(100);\n', '        }\n', '        return (_coinAge * interest).div(365 * (10**decimals));\n', '    }\n', '\n', '    function getCoinAge(address _address, uint _now) internal view returns (uint _coinAge) \n', '    {\n', '        if(txIns[_address].length <= 0) return 0;\n', '\n', '        for (uint i = 0; i < txIns[_address].length; i++){\n', '            if( _now < uint(txIns[_address][i].time).add(stakeMinAge) ) continue;\n', '\n', '            uint nCoinSeconds = _now.sub(uint(txIns[_address][i].time));\n', '            if( nCoinSeconds > stakeMaxAge ) nCoinSeconds = stakeMaxAge;\n', '\n', '            _coinAge = _coinAge.add(uint(txIns[_address][i].amount) * nCoinSeconds.div(1 days));\n', '        }\n', '    }\n', '\n', '    function ownerMultiSend(address[] memory _recipients, uint[] memory _values) onlyOwner public returns (bool) \n', '    {\n', '        require( _recipients.length > 0 && _recipients.length == _values.length);\n', '\n', '        uint total = 0;\n', '        for(uint i = 0; i < _values.length; i++)\n', '        {\n', '            total = total.add(_values[i]);\n', '        }\n', '        require(total <= balances[msg.sender]);\n', '\n', '        uint64 _now = uint64(now);\n', '        for(uint j = 0; j < _recipients.length; j++)\n', '        {\n', '            balances[_recipients[j]] = balances[_recipients[j]].add(_values[j]);\n', '            txIns[_recipients[j]].push(transferInStruct(uint128(_values[j]),_now));\n', '            emit Transfer(msg.sender, _recipients[j], _values[j]);\n', '        }\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(total);\n', '        if(txIns[msg.sender].length > 0) delete txIns[msg.sender];\n', '        if(balances[msg.sender] > 0) txIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));\n', '\n', '        return true;\n', '    }\n', '\n', '    function ownerBurnTokens(uint _value) onlyOwner public \n', '    {\n', '        require(_value > 0);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        delete txIns[msg.sender];\n', '        txIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));\n', '\n', '        totalSupply = totalSupply.sub(_value);\n', '        totalInitialSupply = totalInitialSupply.sub(_value);\n', '        maxTotalSupply = maxTotalSupply.sub(_value*10);\n', '\n', '        emit Burn(msg.sender, _value);\n', '    }   \n', '}']