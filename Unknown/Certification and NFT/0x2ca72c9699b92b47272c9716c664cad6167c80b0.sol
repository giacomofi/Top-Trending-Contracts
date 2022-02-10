['pragma solidity ^0.4.11;\n', '\n', '/*\n', '    Copyright 2017, Shaun Shull\n', '\n', '    This program is free software: you can redistribute it and/or modify\n', '    it under the terms of the GNU General Public License as published by\n', '    the Free Software Foundation, either version 3 of the License, or\n', '    (at your option) any later version.\n', '\n', '    This program is distributed in the hope that it will be useful,\n', '    but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '    GNU General Public License for more details.\n', '\n', '    You should have received a copy of the GNU General Public License\n', '    along with this program.  If not, see <http://www.gnu.org/licenses/>.\n', ' */\n', '\n', '/// @title GUNS Crowdsale Contract - GeoFounders.com\n', '/// @author Shaun Shull\n', '/// @dev Simple single crowdsale contract for fixed supply, single-rate, \n', '///  block-range crowdsale. Additional token cleanup functionality.\n', '\n', '\n', '/// @dev Generic ERC20 Token Interface, totalSupply made to var for compiler\n', 'contract Token {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', '/// @dev ERC20 Standard Token Contract\n', 'contract StandardToken is Token {\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}\n', '\n', '\n', '/// @dev Primary Token Contract\n', 'contract GUNS is StandardToken {\n', '\n', '    // metadata\n', '    string public constant name = "GeoUnits";\n', '    string public constant symbol = "GUNS";\n', '    uint256 public constant decimals = 18;\n', '    string public version = "1.0";\n', '\n', '    // contracts\n', '    address public hostAccount;       // address that kicks off the crowdsale\n', '    address public ethFundDeposit;    // deposit address for ETH for GeoFounders\n', '    address public gunsFundDeposit;   // deposit address for GeoFounders Tokens - GeoUnits (GUNS)\n', '\n', '    // crowdsale parameters\n', '    bool public isFinalized;                                                      // false until crowdsale finalized\n', '    uint256 public fundingStartBlock;                                             // start block\n', '    uint256 public fundingEndBlock;                                               // end block\n', '    uint256 public constant gunsFund = 35 * (10**6) * 10**decimals;               // 35m GUNS reserved for devs\n', '    uint256 public constant tokenExchangeRate = 1000;                             // 1000 GUNS per 1 ETH\n', '    uint256 public constant tokenCreationCap =  100 * (10**6) * 10**decimals;     // 100m GUNS fixed supply\n', '    uint256 public constant tokenCreationMin =  1 * (10**6) * 10**decimals;       // 1m minimum must be in supply (legacy code)\n', '\n', '    // events\n', '    event LogRefund(address indexed _to, uint256 _value);   // event for refund\n', '    event CreateGUNS(address indexed _to, uint256 _value);  // event for token creation\n', '\n', '    // safely add\n', '    function safeAdd(uint256 x, uint256 y) internal returns(uint256) {\n', '        uint256 z = x + y;\n', '        assert((z >= x) && (z >= y));\n', '        return z;\n', '    }\n', '\n', '    // safely subtract\n', '    function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {\n', '      assert(x >= y);\n', '      uint256 z = x - y;\n', '      return z;\n', '    }\n', '\n', '    // safely multiply\n', '    function safeMult(uint256 x, uint256 y) internal returns(uint256) {\n', '      uint256 z = x * y;\n', '      assert((x == 0)||(z/x == y));\n', '      return z;\n', '    }\n', '\n', '    // constructor\n', '    function GUNS() {}\n', '\n', '    // initialize deployed contract\n', '    function initialize(\n', '        address _ethFundDeposit,\n', '        address _gunsFundDeposit,\n', '        uint256 _fundingStartBlock,\n', '        uint256 _fundingEndBlock\n', '    ) public {\n', '        require(address(hostAccount) == 0x0);     // one time initialize\n', '        hostAccount = msg.sender;                 // assign initializer var\n', '        isFinalized = false;                      // crowdsale state\n', '        ethFundDeposit = _ethFundDeposit;         // set final ETH deposit address\n', '        gunsFundDeposit = _gunsFundDeposit;       // set final GUNS dev deposit address\n', '        fundingStartBlock = _fundingStartBlock;   // block number to start crowdsale\n', '        fundingEndBlock = _fundingEndBlock;       // block number to end crowdsale\n', '        totalSupply = gunsFund;                   // update totalSupply to reserve\n', '        balances[gunsFundDeposit] = gunsFund;     // deposit reserve tokens to dev address\n', '        CreateGUNS(gunsFundDeposit, gunsFund);    // logs token creation event\n', '    }\n', '\n', '    // enable people to pay contract directly\n', '    function () public payable {\n', '        require(address(hostAccount) != 0x0);                      // initialization check\n', '\n', '        if (isFinalized) throw;                                    // crowdsale state check\n', '        if (block.number < fundingStartBlock) throw;               // within start block check\n', '        if (block.number > fundingEndBlock) throw;                 // within end block check\n', '        if (msg.value == 0) throw;                                 // person actually sent ETH check\n', '\n', '        uint256 tokens = safeMult(msg.value, tokenExchangeRate);   // calculate num of tokens purchased\n', '        uint256 checkedSupply = safeAdd(totalSupply, tokens);      // calculate total supply if purchased\n', '\n', '        if (tokenCreationCap < checkedSupply) throw;               // if exceeding token max, cancel order\n', '\n', '        totalSupply = checkedSupply;                               // update totalSupply\n', '        balances[msg.sender] += tokens;                            // update token balance for payer\n', '        CreateGUNS(msg.sender, tokens);                            // logs token creation event\n', '    }\n', '\n', '    // generic function to pay this contract\n', '    function emergencyPay() external payable {}\n', '\n', '    // wrap up crowdsale after end block\n', '    function finalize() external {\n', '        //if (isFinalized) throw;                                                        // check crowdsale state is false\n', '        if (msg.sender != ethFundDeposit) throw;                                         // check caller is ETH deposit address\n', '        //if (totalSupply < tokenCreationMin) throw;                                     // check minimum is met\n', '        if (block.number <= fundingEndBlock && totalSupply < tokenCreationCap) throw;    // check past end block unless at creation cap\n', '\n', '        if (!ethFundDeposit.send(this.balance)) throw;                                   // send account balance to ETH deposit address\n', '        \n', '        uint256 remainingSupply = safeSubtract(tokenCreationCap, totalSupply);           // calculate remaining tokens to reach fixed supply\n', '        if (remainingSupply > 0) {                                                       // if remaining supply left\n', '            uint256 updatedSupply = safeAdd(totalSupply, remainingSupply);               // calculate total supply with remaining supply\n', '            totalSupply = updatedSupply;                                                 // update totalSupply\n', '            balances[gunsFundDeposit] += remainingSupply;                                // manually update devs token balance\n', '            CreateGUNS(gunsFundDeposit, remainingSupply);                                // logs token creation event\n', '        }\n', '\n', '        isFinalized = true;                                                              // update crowdsale state to true\n', '    }\n', '\n', '    // legacy code to enable refunds if min token supply not met (not possible with fixed supply)\n', '    function refund() external {\n', '        if (isFinalized) throw;                               // check crowdsale state is false\n', '        if (block.number <= fundingEndBlock) throw;           // check crowdsale still running\n', '        if (totalSupply >= tokenCreationMin) throw;           // check creation min was not met\n', '        if (msg.sender == gunsFundDeposit) throw;             // do not allow dev refund\n', '\n', '        uint256 gunsVal = balances[msg.sender];               // get callers token balance\n', '        if (gunsVal == 0) throw;                              // check caller has tokens\n', '\n', '        balances[msg.sender] = 0;                             // set callers tokens to zero\n', '        totalSupply = safeSubtract(totalSupply, gunsVal);     // subtract callers balance from total supply\n', '        uint256 ethVal = gunsVal / tokenExchangeRate;         // calculate ETH from token exchange rate\n', '        LogRefund(msg.sender, ethVal);                        // log refund event\n', '\n', '        if (!msg.sender.send(ethVal)) throw;                  // send caller their refund\n', '    }\n', '\n', '    // clean up mistaken tokens sent to this contract\n', '    // also check empty address for tokens and clean out\n', '    // (GUNS only, does not support 3rd party tokens)\n', '    function mistakenTokens() external {\n', '        if (msg.sender != ethFundDeposit) throw;                // check caller is ETH deposit address\n', '        \n', '        if (balances[this] > 0) {                               // if contract has tokens\n', '            Transfer(this, gunsFundDeposit, balances[this]);    // log transfer event\n', '            balances[gunsFundDeposit] += balances[this];        // send tokens to dev tokens address\n', '            balances[this] = 0;                                 // zero out contract token balance\n', '        }\n', '\n', '        if (balances[0x0] > 0) {                                // if empty address has tokens\n', '            Transfer(0x0, gunsFundDeposit, balances[0x0]);      // log transfer event\n', '            balances[gunsFundDeposit] += balances[0x0];         // send tokens to dev tokens address\n', '            balances[0x0] = 0;                                  // zero out empty address token balance\n', '        }\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.11;\n', '\n', '/*\n', '    Copyright 2017, Shaun Shull\n', '\n', '    This program is free software: you can redistribute it and/or modify\n', '    it under the terms of the GNU General Public License as published by\n', '    the Free Software Foundation, either version 3 of the License, or\n', '    (at your option) any later version.\n', '\n', '    This program is distributed in the hope that it will be useful,\n', '    but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '    GNU General Public License for more details.\n', '\n', '    You should have received a copy of the GNU General Public License\n', '    along with this program.  If not, see <http://www.gnu.org/licenses/>.\n', ' */\n', '\n', '/// @title GUNS Crowdsale Contract - GeoFounders.com\n', '/// @author Shaun Shull\n', '/// @dev Simple single crowdsale contract for fixed supply, single-rate, \n', '///  block-range crowdsale. Additional token cleanup functionality.\n', '\n', '\n', '/// @dev Generic ERC20 Token Interface, totalSupply made to var for compiler\n', 'contract Token {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', '/// @dev ERC20 Standard Token Contract\n', 'contract StandardToken is Token {\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}\n', '\n', '\n', '/// @dev Primary Token Contract\n', 'contract GUNS is StandardToken {\n', '\n', '    // metadata\n', '    string public constant name = "GeoUnits";\n', '    string public constant symbol = "GUNS";\n', '    uint256 public constant decimals = 18;\n', '    string public version = "1.0";\n', '\n', '    // contracts\n', '    address public hostAccount;       // address that kicks off the crowdsale\n', '    address public ethFundDeposit;    // deposit address for ETH for GeoFounders\n', '    address public gunsFundDeposit;   // deposit address for GeoFounders Tokens - GeoUnits (GUNS)\n', '\n', '    // crowdsale parameters\n', '    bool public isFinalized;                                                      // false until crowdsale finalized\n', '    uint256 public fundingStartBlock;                                             // start block\n', '    uint256 public fundingEndBlock;                                               // end block\n', '    uint256 public constant gunsFund = 35 * (10**6) * 10**decimals;               // 35m GUNS reserved for devs\n', '    uint256 public constant tokenExchangeRate = 1000;                             // 1000 GUNS per 1 ETH\n', '    uint256 public constant tokenCreationCap =  100 * (10**6) * 10**decimals;     // 100m GUNS fixed supply\n', '    uint256 public constant tokenCreationMin =  1 * (10**6) * 10**decimals;       // 1m minimum must be in supply (legacy code)\n', '\n', '    // events\n', '    event LogRefund(address indexed _to, uint256 _value);   // event for refund\n', '    event CreateGUNS(address indexed _to, uint256 _value);  // event for token creation\n', '\n', '    // safely add\n', '    function safeAdd(uint256 x, uint256 y) internal returns(uint256) {\n', '        uint256 z = x + y;\n', '        assert((z >= x) && (z >= y));\n', '        return z;\n', '    }\n', '\n', '    // safely subtract\n', '    function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {\n', '      assert(x >= y);\n', '      uint256 z = x - y;\n', '      return z;\n', '    }\n', '\n', '    // safely multiply\n', '    function safeMult(uint256 x, uint256 y) internal returns(uint256) {\n', '      uint256 z = x * y;\n', '      assert((x == 0)||(z/x == y));\n', '      return z;\n', '    }\n', '\n', '    // constructor\n', '    function GUNS() {}\n', '\n', '    // initialize deployed contract\n', '    function initialize(\n', '        address _ethFundDeposit,\n', '        address _gunsFundDeposit,\n', '        uint256 _fundingStartBlock,\n', '        uint256 _fundingEndBlock\n', '    ) public {\n', '        require(address(hostAccount) == 0x0);     // one time initialize\n', '        hostAccount = msg.sender;                 // assign initializer var\n', '        isFinalized = false;                      // crowdsale state\n', '        ethFundDeposit = _ethFundDeposit;         // set final ETH deposit address\n', '        gunsFundDeposit = _gunsFundDeposit;       // set final GUNS dev deposit address\n', '        fundingStartBlock = _fundingStartBlock;   // block number to start crowdsale\n', '        fundingEndBlock = _fundingEndBlock;       // block number to end crowdsale\n', '        totalSupply = gunsFund;                   // update totalSupply to reserve\n', '        balances[gunsFundDeposit] = gunsFund;     // deposit reserve tokens to dev address\n', '        CreateGUNS(gunsFundDeposit, gunsFund);    // logs token creation event\n', '    }\n', '\n', '    // enable people to pay contract directly\n', '    function () public payable {\n', '        require(address(hostAccount) != 0x0);                      // initialization check\n', '\n', '        if (isFinalized) throw;                                    // crowdsale state check\n', '        if (block.number < fundingStartBlock) throw;               // within start block check\n', '        if (block.number > fundingEndBlock) throw;                 // within end block check\n', '        if (msg.value == 0) throw;                                 // person actually sent ETH check\n', '\n', '        uint256 tokens = safeMult(msg.value, tokenExchangeRate);   // calculate num of tokens purchased\n', '        uint256 checkedSupply = safeAdd(totalSupply, tokens);      // calculate total supply if purchased\n', '\n', '        if (tokenCreationCap < checkedSupply) throw;               // if exceeding token max, cancel order\n', '\n', '        totalSupply = checkedSupply;                               // update totalSupply\n', '        balances[msg.sender] += tokens;                            // update token balance for payer\n', '        CreateGUNS(msg.sender, tokens);                            // logs token creation event\n', '    }\n', '\n', '    // generic function to pay this contract\n', '    function emergencyPay() external payable {}\n', '\n', '    // wrap up crowdsale after end block\n', '    function finalize() external {\n', '        //if (isFinalized) throw;                                                        // check crowdsale state is false\n', '        if (msg.sender != ethFundDeposit) throw;                                         // check caller is ETH deposit address\n', '        //if (totalSupply < tokenCreationMin) throw;                                     // check minimum is met\n', '        if (block.number <= fundingEndBlock && totalSupply < tokenCreationCap) throw;    // check past end block unless at creation cap\n', '\n', '        if (!ethFundDeposit.send(this.balance)) throw;                                   // send account balance to ETH deposit address\n', '        \n', '        uint256 remainingSupply = safeSubtract(tokenCreationCap, totalSupply);           // calculate remaining tokens to reach fixed supply\n', '        if (remainingSupply > 0) {                                                       // if remaining supply left\n', '            uint256 updatedSupply = safeAdd(totalSupply, remainingSupply);               // calculate total supply with remaining supply\n', '            totalSupply = updatedSupply;                                                 // update totalSupply\n', '            balances[gunsFundDeposit] += remainingSupply;                                // manually update devs token balance\n', '            CreateGUNS(gunsFundDeposit, remainingSupply);                                // logs token creation event\n', '        }\n', '\n', '        isFinalized = true;                                                              // update crowdsale state to true\n', '    }\n', '\n', '    // legacy code to enable refunds if min token supply not met (not possible with fixed supply)\n', '    function refund() external {\n', '        if (isFinalized) throw;                               // check crowdsale state is false\n', '        if (block.number <= fundingEndBlock) throw;           // check crowdsale still running\n', '        if (totalSupply >= tokenCreationMin) throw;           // check creation min was not met\n', '        if (msg.sender == gunsFundDeposit) throw;             // do not allow dev refund\n', '\n', '        uint256 gunsVal = balances[msg.sender];               // get callers token balance\n', '        if (gunsVal == 0) throw;                              // check caller has tokens\n', '\n', '        balances[msg.sender] = 0;                             // set callers tokens to zero\n', '        totalSupply = safeSubtract(totalSupply, gunsVal);     // subtract callers balance from total supply\n', '        uint256 ethVal = gunsVal / tokenExchangeRate;         // calculate ETH from token exchange rate\n', '        LogRefund(msg.sender, ethVal);                        // log refund event\n', '\n', '        if (!msg.sender.send(ethVal)) throw;                  // send caller their refund\n', '    }\n', '\n', '    // clean up mistaken tokens sent to this contract\n', '    // also check empty address for tokens and clean out\n', '    // (GUNS only, does not support 3rd party tokens)\n', '    function mistakenTokens() external {\n', '        if (msg.sender != ethFundDeposit) throw;                // check caller is ETH deposit address\n', '        \n', '        if (balances[this] > 0) {                               // if contract has tokens\n', '            Transfer(this, gunsFundDeposit, balances[this]);    // log transfer event\n', '            balances[gunsFundDeposit] += balances[this];        // send tokens to dev tokens address\n', '            balances[this] = 0;                                 // zero out contract token balance\n', '        }\n', '\n', '        if (balances[0x0] > 0) {                                // if empty address has tokens\n', '            Transfer(0x0, gunsFundDeposit, balances[0x0]);      // log transfer event\n', '            balances[gunsFundDeposit] += balances[0x0];         // send tokens to dev tokens address\n', '            balances[0x0] = 0;                                  // zero out empty address token balance\n', '        }\n', '    }\n', '\n', '}']
