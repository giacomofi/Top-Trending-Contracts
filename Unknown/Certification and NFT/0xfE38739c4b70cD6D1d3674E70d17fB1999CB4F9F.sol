['pragma solidity ^0.4.11;\n', '\n', '\n', '\n', '\n', '// ----------------------------------------------------------------------------------------------\n', '// @title MatchPay Token (MPY)\n', '// (c) Federico Capello.\n', '// ----------------------------------------------------------------------------------------------\n', '\n', 'contract MPY {\n', '\n', '    string public constant name = "MatchPay Token";\n', '    string public constant symbol = "MPY";\n', '    uint256 public constant decimals = 18;\n', '\n', '    address owner;\n', '\n', '    uint256 public fundingStartBlock;\n', '    uint256 public fundingEndBlock;\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    uint256 public constant tokenExchangeRate = 10; // 1 MPY per 0.1 ETH\n', '    uint256 public maxCap = 30 * (10**3) * (10**decimals); // Maximum part for offering\n', '    uint256 public totalSupply; // Total part for offering\n', '    uint256 public minCap = 10 * (10**2) * (10**decimals); // Minimum part for offering\n', '    uint256 public ownerTokens = 3 * (10**2) * (10**decimals);\n', '\n', '    bool public isFinalized = false;\n', '\n', '\n', '    // Triggered when tokens are transferred\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '\n', '    // Triggered whenever approve(address _spender, uint256 _value) is called.\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '\n', '    // Triggered when _owner gets tokens\n', '    event MPYCreation(address indexed _owner, uint256 _value);\n', '\n', '\n', '    // Triggered when _owner gets refund\n', '    event MPYRefund(address indexed _owner, uint256 _value);\n', '\n', '\n', '    // -------------------------------------------------------------------------------------------\n', '\n', '\n', '    // Check if ICO is open\n', '    modifier is_live() { require(block.number >= fundingStartBlock && block.number <= fundingEndBlock); _; }\n', '\n', '\n', '    // Only owmer\n', '    modifier only_owner(address _who) { require(_who == owner); _; }\n', '\n', '\n', '    // -------------------------------------------------------------------------------------------\n', '\n', '\n', '    // safely add\n', '    function safeAdd(uint256 x, uint256 y) internal returns(uint256) {\n', '        uint256 z = x + y;\n', '        assert((z >= x) && (z >= y));\n', '        return z;\n', '    }\n', '\n', '    // safely subtract\n', '    function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {\n', '      assert(x >= y);\n', '      uint256 z = x - y;\n', '      return z;\n', '    }\n', '\n', '    // safely multiply\n', '    function safeMult(uint256 x, uint256 y) internal returns(uint256) {\n', '      uint256 z = x * y;\n', '      assert((x == 0)||(z/x == y));\n', '      return z;\n', '    }\n', '\n', '\n', '    // -------------------------------------------------------------------------------------------\n', '\n', '\n', '    // Constructor\n', '    function MPY(\n', '      uint256 _fundingStartBlock,\n', '      uint256 _fundingEndBlock\n', '    ) {\n', '\n', '        owner = msg.sender;\n', '\n', '        fundingStartBlock = _fundingStartBlock;\n', '        fundingEndBlock = _fundingEndBlock;\n', '\n', '    }\n', '\n', '\n', '    /// @notice Return the address balance\n', '    /// @param _owner The owner\n', '    function balanceOf(address _owner) constant returns (uint256) {\n', '      return balances[_owner];\n', '    }\n', '\n', '\n', '    /// @notice Transfer tokens to account\n', '    /// @param _to Beneficiary\n', '    /// @param _amount Number of tokens\n', '    function transfer(address _to, uint256 _amount) returns (bool success) {\n', '      if (balances[msg.sender] >= _amount\n', '          && _amount > 0\n', '          && balances[_to] + _amount > balances[_to]) {\n', '\n', '              balances[msg.sender] -= _amount;\n', '              balances[_to] += _amount;\n', '\n', '              Transfer(msg.sender, _to, _amount);\n', '\n', '              return true;\n', '      } else {\n', '          return false;\n', '      }\n', '    }\n', '\n', '\n', '    /// @notice Transfer tokens on behalf of _from\n', '    /// @param _from From address\n', '    /// @param _to To address\n', '    /// @param _amount Amount of tokens\n', '    function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {\n', '      if (balances[_from] >= _amount\n', '          && allowed[_from][msg.sender] >= _amount\n', '          && _amount > 0\n', '          && balances[_to] + _amount > balances[_to]) {\n', '\n', '              balances[_from] -= _amount;\n', '              allowed[_from][msg.sender] -= _amount;\n', '              balances[_to] += _amount;\n', '\n', '              Transfer(_from, _to, _amount);\n', '\n', '              return true;\n', '          } else {\n', '              return false;\n', '          }\n', '    }\n', '\n', '\n', '    /// @notice Approve transfer of tokens on behalf of _from\n', '    /// @param _spender Whom to approve\n', '    /// @param _amount For how many tokens\n', '    function approve(address _spender, uint256 _amount) returns (bool success) {\n', '      allowed[msg.sender][_spender] = _amount;\n', '      Approval(msg.sender, _spender, _amount);\n', '      return true;\n', '    }\n', '\n', '\n', '    /// @notice Find allowance\n', '    /// @param _owner The owner\n', '    /// @param _spender The approved spender\n', '    function allowance(address _owner, address _spender) constant returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '\n', '    // -------------------------------------------------------------------------------------------\n', '\n', '\n', '    function getStats() constant returns (uint256, uint256, uint256, uint256) {\n', '        return (minCap, maxCap, totalSupply, fundingEndBlock);\n', '    }\n', '\n', '    function getSupply() constant returns (uint256) {\n', '        return totalSupply;\n', '    }\n', '\n', '\n', '    // -------------------------------------------------------------------------------------------\n', '\n', '\n', '    /// @notice Get Tokens: 0.1 ETH per 1 MPY token\n', '    function() is_live() payable {\n', '        if (msg.value == 0) revert();\n', '        if (isFinalized) revert();\n', '\n', '        uint256 tokens = safeMult(msg.value, tokenExchangeRate);   // calculate num of tokens purchased\n', '        uint256 checkedSupply = safeAdd(totalSupply, tokens);      // calculate total supply if purchased\n', '\n', '        if (maxCap < checkedSupply) revert();                         // if exceeding token max, cancel order\n', '\n', '        totalSupply = checkedSupply;                               // update totalSupply\n', '        balances[msg.sender] += tokens;                            // update token balance for payer\n', '        MPYCreation(msg.sender, tokens);                           // logs token creation event\n', '    }\n', '\n', '\n', '    // generic function to pay this contract\n', '    function emergencyPay() external payable {}\n', '\n', '\n', '    // wrap up crowdsale after end block\n', '    function finalize() external {\n', '        if (msg.sender != owner) revert();                                         // check caller is ETH deposit address\n', '        if (totalSupply < minCap) revert();                                        // check minimum is met\n', '        if (block.number <= fundingEndBlock && totalSupply < maxCap) revert();     // check past end block unless at creation cap\n', '\n', '        if (!owner.send(this.balance)) revert();                                   // send account balance to ETH deposit address\n', '\n', '        balances[owner] += ownerTokens;\n', '        totalSupply += ownerTokens;\n', '\n', '        isFinalized = true;                                                     // update crowdsale state to true\n', '    }\n', '\n', '\n', '    // legacy code to enable refunds if min token supply not met (not possible with fixed supply)\n', '    function refund() external {\n', '        if (isFinalized) revert();                               // check crowdsale state is false\n', '        if (block.number <= fundingEndBlock) revert();           // check crowdsale still running\n', '        if (totalSupply >= minCap) revert();                     // check creation min was not met\n', '        if (msg.sender == owner) revert();                       // do not allow dev refund\n', '\n', '        uint256 mpyVal = balances[msg.sender];                // get callers token balance\n', '        if (mpyVal == 0) revert();                               // check caller has tokens\n', '\n', '        balances[msg.sender] = 0;                             // set callers tokens to zero\n', '        totalSupply = safeSubtract(totalSupply, mpyVal);      // subtract callers balance from total supply\n', '        uint256 ethVal = mpyVal / tokenExchangeRate;          // calculate ETH from token exchange rate\n', '        MPYRefund(msg.sender, ethVal);                        // log refund event\n', '\n', '        if (!msg.sender.send(ethVal)) revert();                  // send caller their refund\n', '    }\n', '}']