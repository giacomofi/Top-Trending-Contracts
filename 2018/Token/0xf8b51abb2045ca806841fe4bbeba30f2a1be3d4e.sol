['// ----------------------------------------------------------------------------------------------\n', '// Developer Nechesov Andrey & ObjectMicro, Inc \n', '// ----------------------------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/issues/20\n', '\n', 'pragma solidity ^0.4.23;    \n', '\n', '  library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal returns (uint256) {\n', '      uint256 c = a * b;\n', '      assert(a == 0 || c / a == b);\n', '      return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal returns (uint256) {\n', '      // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '      uint256 c = a / b;\n', '      // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '      return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal returns (uint256) {\n', '      assert(b <= a);\n', '      return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal returns (uint256) {\n', '      uint256 c = a + b;\n', '      assert(c >= a);\n', '      return c;\n', '    }\n', '  }\n', '\n', '  contract ERC20Interface {\n', '      // Get the total token supply\n', '      function totalSupply() constant returns (uint256 totalSupply);\n', '   \n', '      // Get the account balance of another account with address _owner\n', '      function balanceOf(address _owner) constant returns (uint256 balance);\n', '   \n', '      // Send _value amount of tokens to address _to\n', '      function transfer(address _to, uint256 _value) returns (bool success);\n', '   \n', '      // Send _value amount of tokens from address _from to address _to\n', '      function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '   \n', '      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.\n', '      // If this function is called again it overwrites the current allowance with _value.\n', '      // this function is required for some DEX functionality\n', '      function approve(address _spender, uint256 _value) returns (bool success);\n', '   \n', '      // Returns the amount which _spender is still allowed to withdraw from _owner\n', '      function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '   \n', '      // Triggered when tokens are transferred.\n', '      event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '   \n', '      // Triggered whenever approve(address _spender, uint256 _value) is called.\n', '      event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '  }  \n', '   \n', '  contract Bqt_Token is ERC20Interface {\n', '\n', '      string public constant symbol = "BQT";\n', '      string public constant name = "BQT token";\n', '      uint8 public constant decimals = 18; \n', '           \n', '      uint256 public constant maxTokens = 800*10**6*10**18; \n', '      uint256 public constant ownerSupply = maxTokens*51/100;\n', '      uint256 _totalSupply = ownerSupply;  \n', '\n', '      uint256 public constant token_price = 10**18*1/800; \n', '      uint256 public pre_ico_start = 1528416000; // Jun 8, 2018 utc\n', '      uint256 public ico_start = 1531008000; // Jul 8, 2018 utc\n', '      uint256 public ico_finish = 1541635200; // Nov 8, 2018 utc \n', '      uint public constant minValuePre = 10**18*1/1000000; \n', '      uint public constant minValue = 10**18*1/1000000; \n', '      uint public constant maxValue = 3000*10**18;\n', '\n', '      uint8 public constant exchange_coefficient = 102;\n', '\n', '      using SafeMath for uint;\n', '      \n', '      // Owner of this contract\n', '      address public owner;\n', '      address public moderator;\n', '   \n', '      // Balances for each account\n', '      mapping(address => uint256) balances;\n', '   \n', '      // Owner of account approves the transfer of an amount to another account\n', '      mapping(address => mapping (address => uint256)) allowed;\n', '\n', '      // Orders holders who wish sell tokens, save amount\n', '      mapping(address => uint256) public orders_sell_amount;\n', '\n', '      // Orders holders who wish sell tokens, save price\n', '      mapping(address => uint256) public orders_sell_price;\n', '\n', '      //orders list\n', '      address[] public orders_sell_list;\n', '\n', '      // Triggered on set SELL order\n', '      event Order_sell(address indexed _owner, uint256 _max_amount, uint256 _price);      \n', '\n', '      // Triggered on execute SELL order\n', '      event Order_execute(address indexed _from, address indexed _to, uint256 _amount, uint256 _price);      \n', '   \n', '      // Functions with this modifier can only be executed by the owner\n', '      modifier onlyOwner() {\n', '          if (msg.sender != owner) {\n', '              throw;\n', '          }\n', '          _;\n', '      }      \n', '\n', '      // Functions with this modifier can only be executed by the moderator\n', '      modifier onlyModerator() {\n', '          if (msg.sender != moderator) {\n', '              throw;\n', '          }\n', '          _;\n', '      }\n', '\n', '      // Functions change owner\n', '      function changeOwner(address _owner) onlyOwner returns (bool result) {                    \n', '          owner = _owner;\n', '          return true;\n', '      }            \n', '\n', '      // Functions change moderator\n', '      function changeModerator(address _moderator) onlyOwner returns (bool result) {                    \n', '          moderator = _moderator;\n', '          return true;\n', '      }            \n', '   \n', '      // Constructor\n', '      function Bqt_Token() {\n', '          //owner = msg.sender;\n', '          owner = 0x3d143e5f256a4fbc16ef23b29aadc0db67bf0ec2;\n', '          moderator = 0x788C45Dd60aE4dBE5055b5Ac02384D5dc84677b0;\n', '          balances[owner] = ownerSupply;\n', '      }\n', '      \n', '      //default function      \n', '      function() payable {        \n', '          tokens_buy();        \n', '      }\n', '      \n', '      function totalSupply() constant returns (uint256 totalSupply) {\n', '          totalSupply = _totalSupply;\n', '      }\n', '\n', '      //Withdraw money from contract balance to owner\n', '      function withdraw(uint256 _amount) onlyOwner returns (bool result) {\n', '          uint256 balance;\n', '          balance = this.balance;\n', '          if(_amount > 0) balance = _amount;\n', '          owner.send(balance);\n', '          return true;\n', '      }\n', '\n', '      //Change pre_ico_start date\n', '      function change_pre_ico_start(uint256 _pre_ico_start) onlyModerator returns (bool result) {\n', '          pre_ico_start = _pre_ico_start;\n', '          return true;\n', '      }\n', '\n', '      //Change ico_start date\n', '      function change_ico_start(uint256 _ico_start) onlyModerator returns (bool result) {\n', '          ico_start = _ico_start;\n', '          return true;\n', '      }\n', '\n', '      //Change ico_finish date\n', '      function change_ico_finish(uint256 _ico_finish) onlyModerator returns (bool result) {\n', '          ico_finish = _ico_finish;\n', '          return true;\n', '      }\n', '   \n', '      // Total tokens on user address\n', '      function balanceOf(address _owner) constant returns (uint256 balance) {\n', '          return balances[_owner];\n', '      }\n', '   \n', '      // Transfer the balance from owner&#39;s account to another account\n', '      function transfer(address _to, uint256 _amount) returns (bool success) {          \n', '\n', '          if (balances[msg.sender] >= _amount \n', '              && _amount > 0\n', '              && balances[_to] + _amount > balances[_to]) {\n', '              balances[msg.sender] -= _amount;\n', '              balances[_to] += _amount;\n', '              Transfer(msg.sender, _to, _amount);\n', '              return true;\n', '          } else {\n', '              return false;\n', '          }\n', '      }\n', '   \n', '      // Send _value amount of tokens from address _from to address _to\n', '      // The transferFrom method is used for a withdraw workflow, allowing contracts to send\n', '      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge\n', '      // fees in sub-currencies; the command should fail unless the _from account has\n', '      // deliberately authorized the sender of the message via some mechanism; we propose\n', '      // these standardized APIs for approval:\n', '      function transferFrom(\n', '          address _from,\n', '          address _to,\n', '          uint256 _amount\n', '     ) returns (bool success) {         \n', '\n', '         if (balances[_from] >= _amount\n', '             && allowed[_from][msg.sender] >= _amount\n', '             && _amount > 0\n', '             && balances[_to] + _amount > balances[_to]) {\n', '             balances[_from] -= _amount;\n', '             allowed[_from][msg.sender] -= _amount;\n', '             balances[_to] += _amount;\n', '             Transfer(_from, _to, _amount);\n', '             return true;\n', '         } else {\n', '             return false;\n', '         }\n', '     }\n', '  \n', '     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.\n', '     // If this function is called again it overwrites the current allowance with _value.\n', '     function approve(address _spender, uint256 _amount) returns (bool success) {\n', '         allowed[msg.sender][_spender] = _amount;\n', '         Approval(msg.sender, _spender, _amount);\n', '         return true;\n', '     }\n', '    \n', '     //Return param, how many tokens can send _spender from _owner account  \n', '     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '         return allowed[_owner][_spender];\n', '     } \n', '\n', '      /**\n', '      * Buy tokens on pre-ico and ico with bonuses on time boundaries\n', '      */\n', '      function tokens_buy() payable returns (bool) { \n', '\n', '        uint256 tnow = now;\n', '        \n', '        //if(tnow < pre_ico_start) throw;\n', '        if(tnow > ico_finish) throw;\n', '        if(_totalSupply >= maxTokens) throw;\n', '        if(!(msg.value >= token_price)) throw;\n', '        if(!(msg.value >= minValue)) throw;\n', '        if(msg.value > maxValue) throw;\n', '\n', '        uint tokens_buy = (msg.value*10**18).div(token_price);\n', '        uint tokens_buy_total;\n', '\n', '        if(!(tokens_buy > 0)) throw;   \n', '        \n', '        //Bonus for total tokens amount for all contract\n', '        uint b1 = 0;\n', '        //Time bonus on Pre-ICO && ICO\n', '        uint b2 = 0;\n', '        //Individual bonus for tokens amount\n', '        uint b3 = 0;\n', '\n', '        if(_totalSupply <= 5*10**6*10**18) {\n', '          b1 = tokens_buy*30/100;\n', '        }\n', '        if((5*10**6*10**18 < _totalSupply)&&(_totalSupply <= 10*10**6*10**18)) {\n', '          b1 = tokens_buy*25/100;\n', '        }\n', '        if((10*10**6*10**18 < _totalSupply)&&(_totalSupply <= 15*10**6*10**18)) {\n', '          b1 = tokens_buy*20/100;\n', '        }\n', '        if((15*10**6*10**18 < _totalSupply)&&(_totalSupply <= 20*10**6*10**18)) {\n', '          b1 = tokens_buy*15/100;\n', '        }\n', '        if((20*10**6*10**18 < _totalSupply)&&(_totalSupply <= 25*10**6*10**18)) {\n', '          b1 = tokens_buy*10/100;\n', '        }\n', '        if(25*10**6*10**18 <= _totalSupply) {\n', '          b1 = tokens_buy*5/100;\n', '        }        \n', '\n', '        if(tnow < ico_start) {\n', '          b2 = tokens_buy*50/100;\n', '        }\n', '        if((ico_start + 86400*0 <= tnow)&&(tnow < ico_start + 86400*5)){\n', '          b2 = tokens_buy*10/100;\n', '        } \n', '        if((ico_start + 86400*5 <= tnow)&&(tnow < ico_start + 86400*10)){\n', '          b2 = tokens_buy*8/100;        \n', '        } \n', '        if((ico_start + 86400*10 <= tnow)&&(tnow < ico_start + 86400*20)){\n', '          b2 = tokens_buy*6/100;        \n', '        } \n', '        if((ico_start + 86400*20 <= tnow)&&(tnow < ico_start + 86400*30)){\n', '          b2 = tokens_buy*4/100;        \n', '        } \n', '        if(ico_start + 86400*30 <= tnow){\n', '          b2 = tokens_buy*2/100;        \n', '        }\n', '        \n', '\n', '        if((1000*10**18 <= tokens_buy)&&(5000*10**18 <= tokens_buy)) {\n', '          b3 = tokens_buy*5/100;\n', '        }\n', '        if((5001*10**18 <= tokens_buy)&&(10000*10**18 < tokens_buy)) {\n', '          b3 = tokens_buy*10/100;\n', '        }\n', '        if((10001*10**18 <= tokens_buy)&&(15000*10**18 < tokens_buy)) {\n', '          b3 = tokens_buy*15/100;\n', '        }\n', '        if((15001*10**18 <= tokens_buy)&&(20000*10**18 < tokens_buy)) {\n', '          b3 = tokens_buy*20/100;\n', '        }\n', '        if(20001*10**18 <= tokens_buy) {\n', '          b3 = tokens_buy*25/100;\n', '        }\n', '\n', '        tokens_buy_total = tokens_buy.add(b1);\n', '        tokens_buy_total = tokens_buy_total.add(b2);\n', '        tokens_buy_total = tokens_buy_total.add(b3);        \n', '\n', '        if(_totalSupply.add(tokens_buy_total) > maxTokens) throw;\n', '        _totalSupply = _totalSupply.add(tokens_buy_total);\n', '        balances[msg.sender] = balances[msg.sender].add(tokens_buy_total);         \n', '\n', '        return true;\n', '      }\n', '      \n', '      /**\n', '      * Get total SELL orders\n', '      */      \n', '      function orders_sell_total () constant returns (uint256) {\n', '        return orders_sell_list.length;\n', '      } \n', '\n', '      /**\n', '      * Get how many tokens can buy from this SELL order\n', '      */\n', '      function get_orders_sell_amount(address _from) constant returns(uint) {\n', '\n', '        uint _amount_max = 0;\n', '\n', '        if(!(orders_sell_amount[_from] > 0)) return _amount_max;\n', '\n', '        if(balanceOf(_from) > 0) _amount_max = balanceOf(_from);\n', '        if(orders_sell_amount[_from] < _amount_max) _amount_max = orders_sell_amount[_from];\n', '\n', '        return _amount_max;\n', '      }\n', '\n', '      /**\n', '      * User create SELL order.  \n', '      */\n', '      function order_sell(uint256 _max_amount, uint256 _price) returns (bool) {\n', '\n', '        if(!(_max_amount > 0)) throw;\n', '        if(!(_price > 0)) throw;        \n', '\n', '        orders_sell_amount[msg.sender] = _max_amount;\n', '        orders_sell_price[msg.sender] = (_price*exchange_coefficient).div(100);\n', '        orders_sell_list.push(msg.sender);        \n', '\n', '        Order_sell(msg.sender, _max_amount, orders_sell_price[msg.sender]);      \n', '\n', '        return true;\n', '      }\n', '\n', '      /**\n', '      * Order Buy tokens - it&#39;s order search sell order from user _from and if all ok, send token and money \n', '      */\n', '      function order_buy(address _from, uint256 _max_price) payable returns (bool) {\n', '        \n', '        if(!(msg.value > 0)) throw;\n', '        if(!(_max_price > 0)) throw;        \n', '        if(!(orders_sell_amount[_from] > 0)) throw;\n', '        if(!(orders_sell_price[_from] > 0)) throw; \n', '        if(orders_sell_price[_from] > _max_price) throw;\n', '\n', '        uint _amount = (msg.value*10**18).div(orders_sell_price[_from]);\n', '        uint _amount_from = get_orders_sell_amount(_from);\n', '\n', '        if(_amount > _amount_from) _amount = _amount_from;        \n', '        if(!(_amount > 0)) throw;        \n', '\n', '        uint _total_money = (orders_sell_price[_from]*_amount).div(10**18);\n', '        if(_total_money > msg.value) throw;\n', '\n', '        uint _seller_money = (_total_money*100).div(exchange_coefficient);\n', '        uint _buyer_money = msg.value - _total_money;\n', '\n', '        if(_seller_money > msg.value) throw;\n', '        if(_seller_money + _buyer_money > msg.value) throw;\n', '\n', '        if(_seller_money > 0) _from.send(_seller_money);\n', '        if(_buyer_money > 0) msg.sender.send(_buyer_money);\n', '\n', '        orders_sell_amount[_from] -= _amount;        \n', '        balances[_from] -= _amount;\n', '        balances[msg.sender] += _amount; \n', '\n', '        Order_execute(_from, msg.sender, _amount, orders_sell_price[_from]);\n', '\n', '      }\n', '      \n', ' }']