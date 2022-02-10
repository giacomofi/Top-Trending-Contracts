['pragma solidity ^0.4.18;\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '\n', 'contract EthereumUltimate {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '    uint256 public funds;\n', '    address public director;\n', '    bool public saleClosed;\n', '    bool public directorLock;\n', '    uint256 public claimAmount;\n', '    uint256 public payAmount;\n', '    uint256 public feeAmount;\n', '    uint256 public epoch;\n', '    uint256 public retentionMax;\n', '\n', '    mapping (address => uint256) public balances;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '    mapping (address => bool) public buried;\n', '    mapping (address => uint256) public claimed;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    \n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    event Burn(address indexed _from, uint256 _value);\n', '    \n', '    event Bury(address indexed _target, uint256 _value);\n', '    \n', '    event Claim(address indexed _target, address indexed _payout, address indexed _fee);\n', '\n', '    function EthereumUltimate() public {\n', '        director = msg.sender;\n', '        name = "Ethereum Ultimate";\n', '        symbol = "ETHUT";\n', '        decimals = 18;\n', '        saleClosed = false;\n', '        directorLock = false;\n', '        funds = 0;\n', '        totalSupply = 0;\n', '        \n', '        totalSupply += 1000000 * 10 ** uint256(decimals);\n', '        \n', '        // Assign reserved ETHUT supply to the director\n', '        balances[director] = totalSupply;\n', '        \n', '        // Define default values for Ethereum Ultimate functions\n', '        claimAmount = 5 * 10 ** (uint256(decimals) - 1);\n', '        payAmount = 4 * 10 ** (uint256(decimals) - 1);\n', '        feeAmount = 1 * 10 ** (uint256(decimals) - 1);\n', '        \n', '        // Seconds in a year\n', '        epoch = 31536000;\n', '        \n', '        retentionMax = 40 * 10 ** uint256(decimals);\n', '    }\n', '    \n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '    \n', '    modifier onlyDirector {\n', '        require(!directorLock);\n', '        \n', '        require(msg.sender == director);\n', '        _;\n', '    }\n', '    \n', '    modifier onlyDirectorForce {\n', '        require(msg.sender == director);\n', '        _;\n', '    }\n', '    \n', '\n', '    function transferDirector(address newDirector) public onlyDirectorForce {\n', '        director = newDirector;\n', '    }\n', '    \n', '\n', '    function withdrawFunds() public onlyDirectorForce {\n', '        director.transfer(this.balance);\n', '    }\n', '\n', '\t\n', '    function selfLock() public payable onlyDirector {\n', '        require(saleClosed);\n', '        \n', '        require(msg.value == 10 ether);\n', '        \n', '        directorLock = true;\n', '    }\n', '    \n', '    function amendClaim(uint8 claimAmountSet, uint8 payAmountSet, uint8 feeAmountSet, uint8 accuracy) public onlyDirector returns (bool success) {\n', '        require(claimAmountSet == (payAmountSet + feeAmountSet));\n', '        \n', '        claimAmount = claimAmountSet * 10 ** (uint256(decimals) - accuracy);\n', '        payAmount = payAmountSet * 10 ** (uint256(decimals) - accuracy);\n', '        feeAmount = feeAmountSet * 10 ** (uint256(decimals) - accuracy);\n', '        return true;\n', '    }\n', '    \n', '\n', '    function amendEpoch(uint256 epochSet) public onlyDirector returns (bool success) {\n', '        // Set the epoch\n', '        epoch = epochSet;\n', '        return true;\n', '    }\n', '    \n', '\n', '    function amendRetention(uint8 retentionSet, uint8 accuracy) public onlyDirector returns (bool success) {\n', '        // Set retentionMax\n', '        retentionMax = retentionSet * 10 ** (uint256(decimals) - accuracy);\n', '        return true;\n', '    }\n', '    \n', '\n', '    function closeSale() public onlyDirector returns (bool success) {\n', '        // The sale must be currently open\n', '        require(!saleClosed);\n', '        \n', '        // Lock the crowdsale\n', '        saleClosed = true;\n', '        return true;\n', '    }\n', '\n', '\n', '    function openSale() public onlyDirector returns (bool success) {\n', '        // The sale must be currently closed\n', '        require(saleClosed);\n', '        \n', '        // Unlock the crowdsale\n', '        saleClosed = false;\n', '        return true;\n', '    }\n', '    \n', '\n', '    function bury() public returns (bool success) {\n', '        // The address must be previously unburied\n', '        require(!buried[msg.sender]);\n', '        \n', '        // An address must have at least claimAmount to be buried\n', '        require(balances[msg.sender] >= claimAmount);\n', '        \n', '        // Prevent addresses with large balances from getting buried\n', '        require(balances[msg.sender] <= retentionMax);\n', '        \n', '        // Set buried state to true\n', '        buried[msg.sender] = true;\n', '        \n', '        // Set the initial claim clock to 1\n', '        claimed[msg.sender] = 1;\n', '        \n', '        // Execute an event reflecting the change\n', '        Bury(msg.sender, balances[msg.sender]);\n', '        return true;\n', '    }\n', '    \n', '\n', '    function claim(address _payout, address _fee) public returns (bool success) {\n', '        // The claimed address must have already been buried\n', '        require(buried[msg.sender]);\n', '        \n', '        // The payout and fee addresses must be different\n', '        require(_payout != _fee);\n', '        \n', '        // The claimed address cannot pay itself\n', '        require(msg.sender != _payout);\n', '        \n', '        // The claimed address cannot pay itself\n', '        require(msg.sender != _fee);\n', '        \n', '        // It must be either the first time this address is being claimed or atleast epoch in time has passed\n', '        require(claimed[msg.sender] == 1 || (block.timestamp - claimed[msg.sender]) >= epoch);\n', '        \n', '        // Check if the buried address has enough\n', '        require(balances[msg.sender] >= claimAmount);\n', '        \n', '        // Reset the claim clock to the current block time\n', '        claimed[msg.sender] = block.timestamp;\n', '        \n', '        // Save this for an assertion in the future\n', '        uint256 previousBalances = balances[msg.sender] + balances[_payout] + balances[_fee];\n', '        \n', '        // Remove claimAmount from the buried address\n', '        balances[msg.sender] -= claimAmount;\n', '        \n', '        // Pay the website owner that invoked the web node that found the ETHT seed key\n', '        balances[_payout] += payAmount;\n', '        \n', '        // Pay the broker node that unlocked the ETHUT\n', '        balances[_fee] += feeAmount;\n', '        \n', '        // Execute events to reflect the changes\n', '        Claim(msg.sender, _payout, _fee);\n', '        Transfer(msg.sender, _payout, payAmount);\n', '        Transfer(msg.sender, _fee, feeAmount);\n', '        \n', '        // Failsafe logic that should never be false\n', '        assert(balances[msg.sender] + balances[_payout] + balances[_fee] == previousBalances);\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * Crowdsale function\n', '     */\n', '    function () public payable {\n', '        require(!saleClosed);\n', '        \n', '        // Minimum amount is 1 finney\n', '        require(msg.value >= 1 finney);\n', '        \n', '        // Price is 1 ETH = 10000 ETHT\n', '        uint256 amount = msg.value * 30000;\n', '        \n', '        // Supply cap may increase\n', '        require(totalSupply + amount <= (10000000 * 10 ** uint256(decimals)));\n', '        \n', '        // Increases the total supply\n', '        totalSupply += amount;\n', '        \n', '        // Adds the amount to the balance\n', '        balances[msg.sender] += amount;\n', '        \n', '        // Track ETH amount raised\n', '        funds += msg.value;\n', '        \n', '        // Execute an event reflecting the change\n', '        Transfer(this, msg.sender, amount);\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        // Sending addresses cannot be buried\n', '        require(!buried[_from]);\n', '        \n', '        // If the receiving address is buried, it cannot exceed retentionMax\n', '        if (buried[_to]) {\n', '            require(balances[_to] + _value <= retentionMax);\n', '        }\n', '        \n', '        require(_to != 0x0);\n', '        \n', '        require(balances[_from] >= _value);\n', '        \n', '        require(balances[_to] + _value > balances[_to]);\n', '        \n', '        uint256 previousBalances = balances[_from] + balances[_to];\n', '        \n', '        balances[_from] -= _value;\n', '        \n', '        balances[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '        \n', '        assert(balances[_from] + balances[_to] == previousBalances);\n', '    }\n', '\n', '\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        // Check allowance\n', '        require(_value <= allowance[_from][msg.sender]);\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        // Buried addresses cannot be approved\n', '        require(!buried[msg.sender]);\n', '        \n', '        allowance[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        // Buried addresses cannot be burnt\n', '        require(!buried[msg.sender]);\n', '        \n', '        // Check if the sender has enough\n', '        require(balances[msg.sender] >= _value);\n', '        \n', '        // Subtract from the sender\n', '        balances[msg.sender] -= _value;\n', '        \n', '        // Updates totalSupply\n', '        totalSupply -= _value;\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        // Buried addresses cannot be burnt\n', '        require(!buried[_from]);\n', '        \n', '        // Check if the targeted balance is enough\n', '        require(balances[_from] >= _value);\n', '        \n', '        // Check allowance\n', '        require(_value <= allowance[_from][msg.sender]);\n', '        \n', '        // Subtract from the targeted balance\n', '        balances[_from] -= _value;\n', '        \n', "        // Subtract from the sender's allowance\n", '        allowance[_from][msg.sender] -= _value;\n', '        \n', '        // Update totalSupply\n', '        totalSupply -= _value;\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '}']