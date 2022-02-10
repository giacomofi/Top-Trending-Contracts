['pragma solidity ^0.4.11;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    function Ownable() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        require(newOwner != address(0));\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) constant returns (uint256);\n', '    function transfer(address to, uint256 value) returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) constant returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) returns (bool);\n', '    function approve(address spender, uint256 value) returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '\n', 'contract StakerToken {\n', '    uint256 public stakeStartTime;\n', '    uint256 public stakeMinAge;\n', '    uint256 public stakeMaxAge;\n', '    function mint() returns (bool);\n', '    function coinAge() constant returns (uint256);\n', '    function annualInterest() constant returns (uint256);\n', '    event Mint(address indexed _address, uint _reward);\n', '}\n', '\n', '\n', 'contract Staker is ERC20,StakerToken,Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    string public name = "Staker";\n', '    string public symbol = "STR";\n', '    uint public decimals = 18;\n', '\n', '    uint public chainStartTime; \n', '    uint public chainStartBlockNumber; \n', '    uint public stakeStartTime; \n', '    uint public stakeMinAge = 3 days; \n', '    uint public stakeMaxAge = 90 days; \n', '    uint public maxMintProofOfStake = 10**17; \n', '\n', '    uint public totalSupply;\n', '    uint public maxTotalSupply;\n', '    uint public totalInitialSupply;\n', '\n', '    struct transferInStruct{\n', '    uint128 amount;\n', '    uint64 time;\n', '    }\n', '\n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping (address => uint256)) allowed;\n', '    mapping(address => transferInStruct[]) transferIns;\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    /**\n', '     * @dev Fix for the ERC20 short address attack.\n', '     */\n', '    modifier onlyPayloadSize(uint size) {\n', '        require(msg.data.length >= size + 4);\n', '        _;\n', '    }\n', '\n', '    modifier canPoSMint() {\n', '        require(totalSupply < maxTotalSupply);\n', '        _;\n', '    }\n', '\n', '    function Staker() {\n', '        maxTotalSupply = 7000000000000000000000000; \n', '        totalInitialSupply = 1000000000000000000000000; \n', '\n', '        chainStartTime = now;\n', '        chainStartBlockNumber = block.number;\n', '\n', '        balances[msg.sender] = totalInitialSupply;\n', '        totalSupply = totalInitialSupply;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool) {\n', '        if(msg.sender == _to) return mint();\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];\n', '        uint64 _now = uint64(now);\n', '        transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));\n', '        transferIns[_to].push(transferInStruct(uint128(_value),_now));\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) returns (bool) {\n', '        require(_to != address(0));\n', '\n', '        var _allowance = allowed[_from][msg.sender];\n', '\n', '        \n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = _allowance.sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        if(transferIns[_from].length > 0) delete transferIns[_from];\n', '        uint64 _now = uint64(now);\n', '        transferIns[_from].push(transferInStruct(uint128(balances[_from]),_now));\n', '        transferIns[_to].push(transferInStruct(uint128(_value),_now));\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool) {\n', '        require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function mint() canPoSMint returns (bool) {\n', '        if(balances[msg.sender] <= 0) return false;\n', '        if(transferIns[msg.sender].length <= 0) return false;\n', '\n', '        uint reward = getProofOfStakeReward(msg.sender);\n', '        if(reward <= 0) return false;\n', '\n', '        totalSupply = totalSupply.add(reward);\n', '        balances[msg.sender] = balances[msg.sender].add(reward);\n', '        delete transferIns[msg.sender];\n', '        transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));\n', '\n', '        Mint(msg.sender, reward);\n', '        return true;\n', '    }\n', '\n', '    function getBlockNumber() returns (uint blockNumber) {\n', '        blockNumber = block.number.sub(chainStartBlockNumber);\n', '    }\n', '\n', '    function coinAge() constant returns (uint myCoinAge) {\n', '        myCoinAge = getCoinAge(msg.sender,now);\n', '    }\n', '\n', '    function annualInterest() constant returns(uint interest) {\n', '        uint _now = now;\n', '        interest = maxMintProofOfStake;\n', '        if((_now.sub(stakeStartTime)).div(1 years) == 0) {\n', '            interest = (770 * maxMintProofOfStake).div(100);\n', '        } else if((_now.sub(stakeStartTime)).div(1 years) == 1){\n', '            interest = (435 * maxMintProofOfStake).div(100);\n', '        }\n', '    }\n', '\n', '    function getProofOfStakeReward(address _address) internal returns (uint) {\n', '        require( (now >= stakeStartTime) && (stakeStartTime > 0) );\n', '\n', '        uint _now = now;\n', '        uint _coinAge = getCoinAge(_address, _now);\n', '        if(_coinAge <= 0) return 0;\n', '\n', '        uint interest = maxMintProofOfStake;\n', '        \n', '        if((_now.sub(stakeStartTime)).div(1 years) == 0) {\n', '            \n', '            interest = (770 * maxMintProofOfStake).div(100);\n', '        } else if((_now.sub(stakeStartTime)).div(1 years) == 1){\n', '            \n', '            interest = (435 * maxMintProofOfStake).div(100);\n', '        }\n', '\n', '        return (_coinAge * interest).div(365 * (10**decimals));\n', '    }\n', '\n', '    function getCoinAge(address _address, uint _now) internal returns (uint _coinAge) {\n', '        if(transferIns[_address].length <= 0) return 0;\n', '\n', '        for (uint i = 0; i < transferIns[_address].length; i++){\n', '            if( _now < uint(transferIns[_address][i].time).add(stakeMinAge) ) continue;\n', '\n', '            uint nCoinSeconds = _now.sub(uint(transferIns[_address][i].time));\n', '            if( nCoinSeconds > stakeMaxAge ) nCoinSeconds = stakeMaxAge;\n', '\n', '            _coinAge = _coinAge.add(uint(transferIns[_address][i].amount) * nCoinSeconds.div(1 days));\n', '        }\n', '    }\n', '\n', '    function ownerSetStakeStartTime(uint timestamp) onlyOwner {\n', '        require((stakeStartTime <= 0) && (timestamp >= chainStartTime));\n', '        stakeStartTime = timestamp;\n', '    }\n', '\n', '    function ownerBurnToken(uint _value) onlyOwner {\n', '        require(_value > 0);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        delete transferIns[msg.sender];\n', '        transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));\n', '\n', '        totalSupply = totalSupply.sub(_value);\n', '        totalInitialSupply = totalInitialSupply.sub(_value);\n', '        maxTotalSupply = maxTotalSupply.sub(_value*10);\n', '\n', '        Burn(msg.sender, _value);\n', '    }\n', '\n', '    function batchTransfer(address[] _recipients, uint[] _values) onlyOwner returns (bool) {\n', '        require( _recipients.length > 0 && _recipients.length == _values.length);\n', '\n', '        uint total = 0;\n', '        for(uint i = 0; i < _values.length; i++){\n', '            total = total.add(_values[i]);\n', '        }\n', '        require(total <= balances[msg.sender]);\n', '\n', '        uint64 _now = uint64(now);\n', '        for(uint j = 0; j < _recipients.length; j++){\n', '            balances[_recipients[j]] = balances[_recipients[j]].add(_values[j]);\n', '            transferIns[_recipients[j]].push(transferInStruct(uint128(_values[j]),_now));\n', '            Transfer(msg.sender, _recipients[j], _values[j]);\n', '        }\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(total);\n', '        if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];\n', '        if(balances[msg.sender] > 0) transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));\n', '\n', '        return true;\n', '    }\n', '}']
['pragma solidity ^0.4.11;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    function Ownable() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        require(newOwner != address(0));\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) constant returns (uint256);\n', '    function transfer(address to, uint256 value) returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) constant returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) returns (bool);\n', '    function approve(address spender, uint256 value) returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '\n', 'contract StakerToken {\n', '    uint256 public stakeStartTime;\n', '    uint256 public stakeMinAge;\n', '    uint256 public stakeMaxAge;\n', '    function mint() returns (bool);\n', '    function coinAge() constant returns (uint256);\n', '    function annualInterest() constant returns (uint256);\n', '    event Mint(address indexed _address, uint _reward);\n', '}\n', '\n', '\n', 'contract Staker is ERC20,StakerToken,Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    string public name = "Staker";\n', '    string public symbol = "STR";\n', '    uint public decimals = 18;\n', '\n', '    uint public chainStartTime; \n', '    uint public chainStartBlockNumber; \n', '    uint public stakeStartTime; \n', '    uint public stakeMinAge = 3 days; \n', '    uint public stakeMaxAge = 90 days; \n', '    uint public maxMintProofOfStake = 10**17; \n', '\n', '    uint public totalSupply;\n', '    uint public maxTotalSupply;\n', '    uint public totalInitialSupply;\n', '\n', '    struct transferInStruct{\n', '    uint128 amount;\n', '    uint64 time;\n', '    }\n', '\n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping (address => uint256)) allowed;\n', '    mapping(address => transferInStruct[]) transferIns;\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    /**\n', '     * @dev Fix for the ERC20 short address attack.\n', '     */\n', '    modifier onlyPayloadSize(uint size) {\n', '        require(msg.data.length >= size + 4);\n', '        _;\n', '    }\n', '\n', '    modifier canPoSMint() {\n', '        require(totalSupply < maxTotalSupply);\n', '        _;\n', '    }\n', '\n', '    function Staker() {\n', '        maxTotalSupply = 7000000000000000000000000; \n', '        totalInitialSupply = 1000000000000000000000000; \n', '\n', '        chainStartTime = now;\n', '        chainStartBlockNumber = block.number;\n', '\n', '        balances[msg.sender] = totalInitialSupply;\n', '        totalSupply = totalInitialSupply;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool) {\n', '        if(msg.sender == _to) return mint();\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];\n', '        uint64 _now = uint64(now);\n', '        transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));\n', '        transferIns[_to].push(transferInStruct(uint128(_value),_now));\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) returns (bool) {\n', '        require(_to != address(0));\n', '\n', '        var _allowance = allowed[_from][msg.sender];\n', '\n', '        \n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = _allowance.sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        if(transferIns[_from].length > 0) delete transferIns[_from];\n', '        uint64 _now = uint64(now);\n', '        transferIns[_from].push(transferInStruct(uint128(balances[_from]),_now));\n', '        transferIns[_to].push(transferInStruct(uint128(_value),_now));\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool) {\n', '        require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function mint() canPoSMint returns (bool) {\n', '        if(balances[msg.sender] <= 0) return false;\n', '        if(transferIns[msg.sender].length <= 0) return false;\n', '\n', '        uint reward = getProofOfStakeReward(msg.sender);\n', '        if(reward <= 0) return false;\n', '\n', '        totalSupply = totalSupply.add(reward);\n', '        balances[msg.sender] = balances[msg.sender].add(reward);\n', '        delete transferIns[msg.sender];\n', '        transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));\n', '\n', '        Mint(msg.sender, reward);\n', '        return true;\n', '    }\n', '\n', '    function getBlockNumber() returns (uint blockNumber) {\n', '        blockNumber = block.number.sub(chainStartBlockNumber);\n', '    }\n', '\n', '    function coinAge() constant returns (uint myCoinAge) {\n', '        myCoinAge = getCoinAge(msg.sender,now);\n', '    }\n', '\n', '    function annualInterest() constant returns(uint interest) {\n', '        uint _now = now;\n', '        interest = maxMintProofOfStake;\n', '        if((_now.sub(stakeStartTime)).div(1 years) == 0) {\n', '            interest = (770 * maxMintProofOfStake).div(100);\n', '        } else if((_now.sub(stakeStartTime)).div(1 years) == 1){\n', '            interest = (435 * maxMintProofOfStake).div(100);\n', '        }\n', '    }\n', '\n', '    function getProofOfStakeReward(address _address) internal returns (uint) {\n', '        require( (now >= stakeStartTime) && (stakeStartTime > 0) );\n', '\n', '        uint _now = now;\n', '        uint _coinAge = getCoinAge(_address, _now);\n', '        if(_coinAge <= 0) return 0;\n', '\n', '        uint interest = maxMintProofOfStake;\n', '        \n', '        if((_now.sub(stakeStartTime)).div(1 years) == 0) {\n', '            \n', '            interest = (770 * maxMintProofOfStake).div(100);\n', '        } else if((_now.sub(stakeStartTime)).div(1 years) == 1){\n', '            \n', '            interest = (435 * maxMintProofOfStake).div(100);\n', '        }\n', '\n', '        return (_coinAge * interest).div(365 * (10**decimals));\n', '    }\n', '\n', '    function getCoinAge(address _address, uint _now) internal returns (uint _coinAge) {\n', '        if(transferIns[_address].length <= 0) return 0;\n', '\n', '        for (uint i = 0; i < transferIns[_address].length; i++){\n', '            if( _now < uint(transferIns[_address][i].time).add(stakeMinAge) ) continue;\n', '\n', '            uint nCoinSeconds = _now.sub(uint(transferIns[_address][i].time));\n', '            if( nCoinSeconds > stakeMaxAge ) nCoinSeconds = stakeMaxAge;\n', '\n', '            _coinAge = _coinAge.add(uint(transferIns[_address][i].amount) * nCoinSeconds.div(1 days));\n', '        }\n', '    }\n', '\n', '    function ownerSetStakeStartTime(uint timestamp) onlyOwner {\n', '        require((stakeStartTime <= 0) && (timestamp >= chainStartTime));\n', '        stakeStartTime = timestamp;\n', '    }\n', '\n', '    function ownerBurnToken(uint _value) onlyOwner {\n', '        require(_value > 0);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        delete transferIns[msg.sender];\n', '        transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));\n', '\n', '        totalSupply = totalSupply.sub(_value);\n', '        totalInitialSupply = totalInitialSupply.sub(_value);\n', '        maxTotalSupply = maxTotalSupply.sub(_value*10);\n', '\n', '        Burn(msg.sender, _value);\n', '    }\n', '\n', '    function batchTransfer(address[] _recipients, uint[] _values) onlyOwner returns (bool) {\n', '        require( _recipients.length > 0 && _recipients.length == _values.length);\n', '\n', '        uint total = 0;\n', '        for(uint i = 0; i < _values.length; i++){\n', '            total = total.add(_values[i]);\n', '        }\n', '        require(total <= balances[msg.sender]);\n', '\n', '        uint64 _now = uint64(now);\n', '        for(uint j = 0; j < _recipients.length; j++){\n', '            balances[_recipients[j]] = balances[_recipients[j]].add(_values[j]);\n', '            transferIns[_recipients[j]].push(transferInStruct(uint128(_values[j]),_now));\n', '            Transfer(msg.sender, _recipients[j], _values[j]);\n', '        }\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(total);\n', '        if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];\n', '        if(balances[msg.sender] > 0) transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));\n', '\n', '        return true;\n', '    }\n', '}']
