['pragma solidity ^0.5.8;\n', '\n', '\n', '\n', '//-----------------------------------------------------------------------------\n', '/*\n', '\n', 'YFG is fork of Yearn Finance Gold.\n', 'The core development team is made up of a team of people from different countries who have high experience in the crypto environment.\n', 'The YFG technology is independently forked and upgraded to a cluster interactive intelligent aggregator,\n', 'which aggregates multiple platforms Agreement to realize the interaction of assets on different decentralized liquidity platforms.\n', '\n', '*/\n', '//-----------------------------------------------------------------------------\n', '\n', '// Sample token contract\n', '//\n', '// Symbol        : YFG\n', '// Name          : Yearn Finance Gold\n', '// Total supply  : 30000\n', '// Decimals      : 18\n', '// Owner Account : 0x38Eee2ddcFE6B6C0C4166347f2571ffBFce7d6E0\n', '//\n', '// Enjoy.\n', '//\n', '// (c) by Yearn Finance Gold 2020. MIT Licence.\n', '// ----------------------------------------------------------------------------\n', '\n', '\n', 'contract YearnFinanceGold {\n', '    // Name your custom token\n', '    string public constant name = "Yearn Finance.Gold";\n', '\n', '    // Name your custom token symbol\n', '    string public constant symbol = "YFG";\n', '\n', '    uint8 public constant decimals = 18;\n', '    \n', '    // Contract owner will be your Link account\n', '    address public owner;\n', '\n', '    address public treasury;\n', '\n', '    uint256 public totalSupply;\n', '\n', '    mapping (address => mapping (address => uint256)) private allowed;\n', '    mapping (address => uint256) private balances;\n', '\n', '    event Approval(address indexed tokenholder, address indexed spender, uint256 value);\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '\n', '        \n', '        treasury = address(0x38Eee2ddcFE6B6C0C4166347f2571ffBFce7d6E0);\n', '\n', '        // Set your total token supply (default 1000)\n', '        totalSupply = 30000 * 10**uint(decimals);\n', '\n', '        balances[treasury] = totalSupply;\n', '        emit Transfer(address(0), treasury, totalSupply);\n', '    }\n', '\n', '    function () external payable {\n', '        revert();\n', '    }\n', '\n', '    function allowance(address _tokenholder, address _spender) public view returns (uint256 remaining) {\n', '        return allowed[_tokenholder][_spender];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        require(_spender != address(0));\n', '        require(_spender != msg.sender);\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '\n', '        emit Approval(msg.sender, _spender, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _tokenholder) public view returns (uint256 balance) {\n', '        return balances[_tokenholder];\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {\n', '        require(_spender != address(0));\n', '        require(_spender != msg.sender);\n', '\n', '        if (allowed[msg.sender][_spender] <= _subtractedValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = allowed[msg.sender][_spender] - _subtractedValue;\n', '        }\n', '\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '\n', '        return true;\n', '    }\n', '    \n', '    \n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     *\n', '     * Emits a `Transfer` event.\n', '     */\n', '     \n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {\n', '        require(_spender != address(0));\n', '        require(_spender != msg.sender);\n', '        require(allowed[msg.sender][_spender] <= allowed[msg.sender][_spender] + _addedValue);\n', '\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender] + _addedValue;\n', '\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '\n', '        return true;\n', '    }\n', '    \n', '    \n', '     /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through `transferFrom`. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when `approve` or `transferFrom` are called.\n', '     */\n', '     \n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != msg.sender);\n', '        require(_to != address(0));\n', '        require(_to != address(this));\n', '        require(balances[msg.sender] - _value <= balances[msg.sender]);\n', '        require(balances[_to] <= balances[_to] + _value);\n', '        require(_value <= transferableTokens(msg.sender));\n', '\n', '        balances[msg.sender] = balances[msg.sender] - _value;\n', '        balances[_to] = balances[_to] + _value;\n', '\n', '        emit Transfer(msg.sender, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_from != address(0));\n', '        require(_from != address(this));\n', '        require(_to != _from);\n', '        require(_to != address(0));\n', '        require(_to != address(this));\n', '        require(_value <= transferableTokens(_from));\n', '        require(allowed[_from][msg.sender] - _value <= allowed[_from][msg.sender]);\n', '        require(balances[_from] - _value <= balances[_from]);\n', '        require(balances[_to] <= balances[_to] + _value);\n', '\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;\n', '        balances[_from] = balances[_from] - _value;\n', '        balances[_to] = balances[_to] + _value;\n', '\n', '        emit Transfer(_from, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public {\n', '        require(msg.sender == owner);\n', '        require(_newOwner != address(0));\n', '        require(_newOwner != address(this));\n', '        require(_newOwner != owner);\n', '\n', '        address previousOwner = owner;\n', '        owner = _newOwner;\n', '\n', '        emit OwnershipTransferred(previousOwner, _newOwner);\n', '    }\n', '    \n', '    \n', '\n', '    function transferableTokens(address holder) public view returns (uint256) {\n', '        return balanceOf(holder);\n', '    }\n', '}']