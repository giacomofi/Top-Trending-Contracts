['pragma solidity ^0.4.18;\n', '\n', '/// @title SafeMath\n', '/// @dev Math operations with safety checks that throw on error\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/// @title ERC20 Standard Token interface\n', 'contract IERC20Token {\n', '    uint256 public totalSupply;\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance);\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event Burn(address indexed from, uint256 value);\n', '}\n', '\n', '/// @title ERC20 Standard Token implementation\n', 'contract ERC20Token is IERC20Token {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) public balances;\n', '    mapping (address => mapping (address => uint256)) public allowed;\n', '\n', '    modifier validAddress(address _address) {\n', '        require(_address != 0x0);\n', '        require(_address != address(this));\n', '        _;\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal validAddress(_to) {\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '\n', '        Transfer(_from, _to, _value);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        _transfer(msg.sender, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '\n', '        _transfer(_from, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public validAddress(_spender) returns (bool success) {\n', '        require(_value == 0 || allowed[msg.sender][_spender] == 0);\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '\n', '        Approval(msg.sender, _spender, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '}\n', '\n', 'contract Owned {\n', '\n', '    address public owner;\n', '\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier validAddress(address _address) {\n', '        require(_address != 0x0);\n', '        require(_address != address(this));\n', '        _;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        assert(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public validAddress(_newOwner) onlyOwner {\n', '        require(_newOwner != owner);\n', '\n', '        owner = _newOwner;\n', '    }\n', '}\n', '\n', '/// @title BC2B contract - crowdfunding code for BC2B Project\n', 'contract BC2BToken is ERC20Token, Owned {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    string public constant name = "BC2B";\n', '    string public constant symbol = "BC2B";\n', '    uint32 public constant decimals = 18;\n', '\n', '    // SET current initial token supply\n', '    uint256 public initialSupply = 10000000;\n', '    // \n', '    bool public fundingEnabled = true;\n', '    // The maximum tokens available for sale\n', '    uint256 public maxSaleToken;\n', '    // Total number of tokens sold\n', '    uint256 public totalSoldTokens;\n', '    // Total number of tokens for BC2B Project\n', '    uint256 public totalProjectToken;\n', '    // Funding wallets, which allowed the transaction during the crowdfunding\n', '    address[] public wallets;\n', '    // The flag indicates if the BC2B contract is in enable / disable transfers\n', '    bool public transfersEnabled = true; \n', '\n', '    // List wallets to allow transactions tokens\n', '    uint[256] private nWallets;\n', '    // Index on the list of wallets to allow reverse lookup\n', '    mapping(uint => uint) private iWallets;\n', '\n', '    event Finalize();\n', '    event DisableTransfers();\n', '\n', '    /// @notice BC2B Project\n', '    /// @dev Constructor\n', '    function BC2BToken() public {\n', '\n', '        initialSupply = initialSupply * 10 ** uint256(decimals);\n', '\n', '        totalSupply = initialSupply;\n', '        // Initializing 60% of tokens for sale\n', '        // maxSaleToken = initialSupply * 60 / 100 (60% this is maxSaleToken & 100% this is initialSupply)\n', '        // totalProjectToken will be calculated in function finalize()\n', '        // \n', '        // |------------maxSaleToken------totalProjectToken|\n', '        // |================60%================|====40%====|\n', '        // |------------------totalSupply------------------|\n', '        maxSaleToken = totalSupply.mul(60).div(100);\n', '        // Give all the tokens to a COLD wallet\n', '        balances[msg.sender] = maxSaleToken;\n', '        // SET HOT wallets\n', '        wallets = [\n', '                0xbED1c18C16868D7C34CEE770e10ae3175b4809Ce,\n', '                0x6F8E76fd90153D4a73491044972a4edE1e216a26,\n', '                0xB75D0fa5C82956CBA2724344B74261DC6dc74CDa\n', '            ];\n', '        // Add COLD wallet (owner)\n', '        nWallets[1] = uint(msg.sender);\n', '        iWallets[uint(msg.sender)] = 1;\n', '\n', '        for (uint index = 0; index < wallets.length; index++) {\n', '            nWallets[2 + index] = uint(wallets[index]);\n', '            iWallets[uint(wallets[index])] = index + 2;\n', '        }\n', '    }\n', '\n', '    modifier validAddress(address _address) {\n', '        require(_address != 0x0);\n', '        require(_address != address(this));\n', '        _;\n', '    }\n', '\n', '    modifier transfersAllowed() {\n', '        require(transfersEnabled);\n', '        _;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public transfersAllowed() returns (bool success) {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed() returns (bool) {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function _transferProject(address _to, uint256 _value) private {\n', '        balances[_to] = balances[_to].add(_value);\n', '\n', '        Transfer(this, _to, _value);\n', '    }\n', '\n', '    function finalize() external onlyOwner {\n', '        require(fundingEnabled);\n', '\n', '        uint256 soldTokens = maxSaleToken;\n', '\n', '        for (uint index = 1; index < nWallets.length; index++) {\n', '            if (balances[address(nWallets[index])] > 0) {\n', '                // Get total sold tokens on the funding wallets\n', '                // totalSoldTokens is 60% of the total number of tokens\n', '                soldTokens = soldTokens.sub(balances[address(nWallets[index])]);\n', '\n', '                Burn(address(nWallets[index]), balances[address(nWallets[index])]);\n', '                // Burning tokens on funding wallet\n', '                balances[address(nWallets[index])] = 0;\n', '            }\n', '        }\n', '\n', '        totalSoldTokens = soldTokens;\n', '\n', '        // totalProjectToken = totalSoldTokens * 40 / 60 (40% this is BC2B Project & 60% this is totalSoldTokens)\n', '        //\n', '        // |----------totalSoldTokens-----totalProjectToken|\n', '        // |================60%================|====40%====|\n', '        // |totalSupply=(totalSoldTokens+totalProjectToken)|\n', '        totalProjectToken = totalSoldTokens.mul(40).div(60);\n', '\n', '        totalSupply = totalSoldTokens.add(totalProjectToken);\n', '        // SET 40% of totalSupply tokens for BC2B\n', '        _transferProject(0xB09Df01b913eb1975e16b408eDe9Ecb8360A1627, totalSupply.mul(40).div(100));\n', '\n', '        fundingEnabled = false;\n', '\n', '        Finalize();\n', '    }\n', '\n', '    function disableTransfers() external onlyOwner {\n', '        require(transfersEnabled);\n', '\n', '        transfersEnabled = false;\n', '\n', '        DisableTransfers();\n', '    }\n', '}']