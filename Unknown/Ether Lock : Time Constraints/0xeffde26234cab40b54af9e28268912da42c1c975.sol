['// This is ERC 2.0 Token&#39;s Trading Market, Decentralized Exchange Contract. 这是一个ERC20Token的去中心化交易所合同。\n', '// 支持使用以太币买卖任意满足ERC20标准的Token。其具体使用流程请参见对应文档。\n', '// by he.guanjun, email: <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="533b367d377d377d203b323d133b3c273e323a3f7d303c3e">[email&#160;protected]</a>\n', '// 2017-09-28 update\n', '// TODO：\n', '//  1,每一个function，都应该写日志（事件），而且最好不要共用事件。暂不处理。\n', '//  2,Token白名单，更安全，但是需要owner维护，更麻烦。暂不处理。\n', '// 强调：在任何时候调用外部合约的function，都要仔细检查外部合约再调用本合约的任意function是否产生异常后果！预防The DAO事件的错误！作为一种编码习惯，所有的调用外部合约function的地方都要标记出来！\n', '// 处理的方式包括：减少先记账，后转钱；增加先转钱，后记账；输入检查；msg.sender,tx.origin检查；锁定；等。暂时采用锁定，可以极大简化测试路径。\n', '\n', '\n', 'pragma solidity ^0.4.11; \n', '\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/issues/20\n', 'interface Erc20Token {\n', '      function totalSupply() constant returns (uint256 totalSupply);\n', '      function balanceOf(address _owner) constant returns (uint256 balance);\n', '\n', '      function transfer(address _to, uint256 _value) returns (bool success);\n', '\n', '      function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '      function approve(address _spender, uint256 _value) returns (bool success);\n', '      function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '\n', '      event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '      event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '      function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success);\n', '}\n', '\n', 'contract Base { \n', '    uint createTime = now;\n', '\n', '    address public owner;\n', '    \n', '    function Base() {\n', '        owner = msg.sender;\n', '    }\n', '    \n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    function transferOwnership(address _newOwner)  public  onlyOwner {\n', '        owner = _newOwner;\n', '    }\n', '\n', '    mapping (address => uint256) public userEtherOf;   \n', '\n', '    function userRefund() public   {\n', '        //require(msg.sender == tx.origin);     //TODO：\n', '         _userRefund(msg.sender, msg.sender);\n', '    }\n', '\n', '    function userRefundTo(address _to) public   {\n', '        //require(msg.sender == tx.origin);     //TODO：\n', '        _userRefund(msg.sender, _to);\n', '    }\n', '\n', '    function _userRefund(address _from,  address _to) private {\n', '        require (_to != 0x0);  \n', '        lock();\n', '        uint256 amount = userEtherOf[_from];\n', '        if(amount > 0){\n', '            userEtherOf[_from] -= amount;\n', '            _to.transfer(amount);               //防范外部调用，特别是和支付（买Token）联合调用就有风险， 2017-09-27\n', '        }\n', '        unLock();\n', '    }\n', '\n', '    bool public globalLocked = false;      //锁定，全局，外部智能调用一个方法！ 2017-10-02\n', '\n', '    function lock() internal {              //在 lock 和 unLock 之间，最好不要写有 require 之类会抛出异常的语句，而是在 lock 之前全面检查。\n', '        require(!globalLocked);\n', '        globalLocked = true;\n', '    }\n', '\n', '    function unLock() internal {\n', '        require(globalLocked);\n', '        globalLocked = false;\n', '    }    \n', '\n', '    //event OnSetLock(bool indexed _oldGlobalLocked, bool indexed _newGlobalLocked);\n', '\n', '    function setLock()  public onlyOwner{       //sometime, globalLocked always is true???\n', '        //bool _oldGlobalLocked = globalLocked;\n', '        globalLocked = false;     \n', '        //OnSetLock(_oldGlobalLocked, false);   \n', '    }\n', '}\n', '\n', '//执行 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }\n', 'contract  Erc20TokenMarket is Base         //for exchange token\n', '{\n', '    function Erc20TokenMarket()  Base ()  {\n', '    }\n', '\n', '    mapping (address => uint) public badTokenOf;      //Token 黑名单！\n', '\n', '    event OnBadTokenChanged(address indexed _tokenAddress, uint indexed _badNum);\n', '\n', '    function addBadToken(address _tokenAddress) public onlyOwner{\n', '        badTokenOf[_tokenAddress] += 1;\n', '        OnBadTokenChanged(_tokenAddress, badTokenOf[_tokenAddress]);\n', '    }\n', '\n', '    function removeBadToken(address _tokenAddress) public onlyOwner{\n', '        badTokenOf[_tokenAddress] = 0;\n', '        OnBadTokenChanged(_tokenAddress, badTokenOf[_tokenAddress]);\n', '    }\n', '\n', '    function isBadToken(address _tokenAddress) private returns(bool _result) {\n', '        return badTokenOf[_tokenAddress] > 0;        \n', '    }\n', '\n', '    uint256 public sellerGuaranteeEther = 0 ether;      //保证金，最大惩罚金额。\n', '\n', '    function setSellerGuarantee(uint256 _gurateeEther) public onlyOwner {\n', '        require(now - createTime > 1 years);        //至少一年后才启用保证金\n', '        require(_gurateeEther <= 0.1 ether);        //不能太高，表示一下，能够拒绝恶意者就好。\n', '        sellerGuaranteeEther = _gurateeEther;        \n', '    }    \n', '\n', '    function checkSellerGuarantee(address _seller) private returns (bool _result){\n', '        return userEtherOf[_seller] >= sellerGuaranteeEther;            //保证金不强制冻结，如果保证金不足，将无法完成交易（买和卖）。\n', '    }\n', '\n', '    function userRefundWithoutGuaranteeEther() public   {       //退款，但是保留保证金\n', '        lock();\n', '\n', '        if (userEtherOf[msg.sender] > 0 && userEtherOf[msg.sender] >= sellerGuaranteeEther){\n', '            uint256 amount = userEtherOf[msg.sender] - sellerGuaranteeEther;\n', '            userEtherOf[msg.sender] -= amount;\n', '            msg.sender.transfer(amount);            //防范外部调用 2017-09-28\n', '        }\n', '\n', '        unLock();\n', '    }\n', '\n', '    struct SellingToken{                //TokenInfo，包括：当前金额，已卖总金额，出售价格，是否出售，出售时间限制，转入总金额，转入总金额， TODO：\n', '        uint256    thisAmount;          //currentAmount，当前金额，可以出售的金额,转入到 this 地址的金额。\n', '        uint256    soldoutAmount;       //有可能溢出，恶意合同能做到这点，但不影响合约执行，暂不处理。 2017-09-27\n', '        uint256    price;      \n', '        bool       cancel;              //正在出售，是否出售\n', '        uint       lineTime;            //出售时间限制\n', '    }    \n', '\n', '    mapping (address => mapping(address => SellingToken)) public userSellingTokenOf;    //销售者，代币地址，销售信息\n', '\n', '    //event OnReceiveApproval(address indexed _tokenAddress, address _seller, uint indexed _sellingAmount, uint256 indexed _price, uint _lineTime, bool _cancel);\n', '    event OnSetSellingToken(address indexed _tokenAddress, address _seller, uint indexed _sellingAmount, uint256 indexed _price, uint _lineTime, bool _cancel);\n', '    //event OnCancelSellingToken(address indexed _tokenAddress, address _seller, uint indexed _sellingAmount, uint256 indexed _price, uint _lineTime, bool _cancel);\n', '\n', '    function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public {\n', '        _extraData;\n', '        _value;\n', '        require(_from != 0x0);\n', '        require(_token != 0x0);\n', '        //require(_value > 0);              //no\n', '        require(_token == msg.sender && msg.sender != tx.origin);   //防范攻击，防止被发送大量的垃圾信息！就算攻击，也要写一个智能合约来攻击！\n', '        require(!isBadToken(msg.sender));                           //黑名单判断，主要防范垃圾信息，\n', '\n', '        lock();\n', '\n', '        Erc20Token token = Erc20Token(msg.sender);\n', '        var sellingAmount = token.allowance(_from, this);   //_from == tx.origin != msg.sender = _token , _from == tx.origin 不一定，但一般如此，多重签名钱包就不是。\n', '\n', '        //var sa = token.balanceOf(_from);        //检查用户实际拥有的Token，但用户拥有的Token随时可能变化，所以还是无法检查，只能在购买的时候检查。\n', '        //if (sa < sellingAmount){\n', '        //    sellingAmount = sa;\n', '        //}\n', '\n', '        //require(sellingAmount > 0);       //no \n', '\n', '        var st = userSellingTokenOf[_from][_token];                 //用户(卖家)地址， Token地址，\n', '        st.thisAmount = sellingAmount;\n', '        //st.price = 0;\n', '        //st.lineTime = 0;\n', '        //st.cancel = true;      \n', '        OnSetSellingToken(_token, _from, sellingAmount, st.price, st.lineTime, st.cancel);\n', '        unLock();\n', '    }\n', '      \n', '    function setSellingToken(address _tokenAddress,  uint256 _price, uint _lineTime) public returns(uint256  _sellingAmount) {\n', '        require(_tokenAddress != 0x0);\n', '        require(_price > 0);\n', '        require(_lineTime > now);\n', '        require(!isBadToken(_tokenAddress));                //黑名单\n', '        require(checkSellerGuarantee(msg.sender));          //保证金，\n', '        lock();\n', '\n', '        Erc20Token token = Erc20Token(_tokenAddress);\n', '        _sellingAmount = token.allowance(msg.sender,this);      //防范外部调用， 2017-09-27\n', '\n', '        //var sa = token.balanceOf(_from);        //检查用户实际拥有的Token\n', '        //if (sa < _sellingAmount){\n', '        //    _sellingAmount = sa;\n', '        //}\n', '\n', '        var st = userSellingTokenOf[msg.sender][_tokenAddress];\n', '        st.thisAmount = _sellingAmount;\n', '        st.price = _price;\n', '        st.lineTime = _lineTime;\n', '        st.cancel = false;\n', '\n', '        OnSetSellingToken(_tokenAddress, msg.sender, _sellingAmount, _price, _lineTime, st.cancel);\n', '        unLock();\n', '    }   \n', '\n', '    function cancelSellingToken(address _tokenAddress)  public{     // returns(bool _result) delete , 2017-09-27\n', '        require(_tokenAddress != 0x0);    \n', '        \n', '        lock();\n', '\n', '        var st = userSellingTokenOf[msg.sender][_tokenAddress];\n', '        st.cancel = true;\n', '        \n', '        Erc20Token token = Erc20Token(_tokenAddress);\n', '        var sellingAmount = token.allowance(msg.sender,this);   //防范外部调用， 2017-09-27\n', '        st.thisAmount = sellingAmount;\n', '        \n', '        OnSetSellingToken(_tokenAddress, msg.sender, sellingAmount, st.price, st.lineTime, st.cancel);\n', '\n', '        unLock();\n', '    }    \n', '\n', '    event OnBuyToken(address _buyer, uint _buyerRamianEtherAmount, address indexed _seller, address indexed _tokenAddress, uint256  _transTokenAmount, uint256 indexed _tokenPrice, uint256 _sellerRamianTokenAmount);\n', '    //event OnBuyToken(address _buyer, address indexed _seller, address indexed _tokenAddress, uint256  _transTokenAmount, uint256 indexed _tokenPrice, uint256 _sellerRamianTokenAmount);\n', '\n', '    function buyTokenFrom(address _seller, address _tokenAddress, uint256 _buyerTokenPrice) public payable returns(bool _result) {   \n', '        require(_seller != 0x0);\n', '        require(_tokenAddress != 0x0);\n', '        require(_buyerTokenPrice > 0);\n', '\n', '        lock();              //加锁  //拒绝二次进入！   //防范外部调用，某些特殊合约可能无法成功执行此方法，但为了安全就这么简单处理。 2017-09-27\n', '        \n', '        _result = false;\n', '\n', '        userEtherOf[msg.sender] += msg.value;\n', '        if (userEtherOf[msg.sender] == 0){\n', '            unLock();\n', '            return; \n', '        }\n', '\n', '        Erc20Token token = Erc20Token(_tokenAddress);\n', '        var sellingAmount = token.allowance(_seller, this);     //卖家， _spender   \n', '        var st = userSellingTokenOf[_seller][_tokenAddress];    //卖家，Token\n', '\n', '        var sa = token.balanceOf(_seller);        //检查用户实际拥有的Token，但用户拥有的Token随时可能变化，只能在购买的时候检查。\n', '        bool bigger = false;\n', '        if (sa < sellingAmount){                  //一种策略，卖家交定金，如果发现出现这种情况，定金没收，owner 和 买家平分定金。\n', '            sellingAmount = sa;\n', '            bigger = true;\n', '        }\n', '\n', '        if (st.price > 0 && st.lineTime > now && sellingAmount > 0 && !st.cancel){\n', '            if(_buyerTokenPrice < st.price){                                                //price maybe be changed!\n', '                OnBuyToken(msg.sender, userEtherOf[msg.sender], _seller, _tokenAddress, 0, st.price, sellingAmount);\n', '                unLock();\n', '                return;\n', '            }\n', '\n', '            uint256 canTokenAmount =  userEtherOf[msg.sender]  / st.price;      \n', '            if(canTokenAmount > 0 && canTokenAmount *  st.price >  userEtherOf[msg.sender]){\n', '                 canTokenAmount -= 1;\n', '            }\n', '            if(canTokenAmount == 0){\n', '                OnBuyToken(msg.sender, userEtherOf[msg.sender], _seller, _tokenAddress, 0, st.price, sellingAmount);\n', '                unLock();\n', '                return;\n', '            }\n', '            if (canTokenAmount > sellingAmount){\n', '                canTokenAmount = sellingAmount; \n', '            }\n', '            \n', '            var etherAmount =  canTokenAmount *  st.price;      //这里不存在溢出，因为 canTokenAmount =  userEtherOf[msg.sender]  / st.price;      2017-09-27\n', '            userEtherOf[msg.sender] -= etherAmount;                     //减少记账金额\n', '            //require(userEtherOf[msg.sender] >= 0);                      //冗余判断: 必然，uint数据类型。2017-09-27 delete\n', '\n', '            token.transferFrom(_seller, msg.sender, canTokenAmount);    //转代币, ，预防类似 the dao 潜在的风险       \n', '            if(userEtherOf[_seller]  >= sellerGuaranteeEther){          //大于等于最低保证金，这样鼓励卖家存留一点保证金。            \n', '                _seller.transfer(etherAmount);                          //转以太币，预防类似 the dao 潜在的风险      \n', '            }   \n', '            else{                                                       //小于最低保证金\n', '                userEtherOf[_seller] +=  etherAmount;                   //由推改为拖，更安全！ //这里不存在溢出，2017-09-27\n', '            }      \n', '            st.soldoutAmount += canTokenAmount;                         //更新销售额     //可能溢出，只有恶意调用才可能出现溢出，溢出也不影响交易，不处理。 2017-09-27\n', '            st.thisAmount = token.allowance(_seller, this);             //更新可销售代币数量\n', '\n', '            OnBuyToken(msg.sender, userEtherOf[msg.sender], _seller, _tokenAddress, canTokenAmount, st.price, st.thisAmount);     \n', '            _result = true;\n', '        }\n', '        else{\n', '            _result = false;\n', '            OnBuyToken(msg.sender, userEtherOf[msg.sender], _seller, _tokenAddress, 0, st.price, sellingAmount);\n', '        }\n', '\n', '        if (bigger && sellerGuaranteeEther > 0){                                  //虚报可出售Token，要惩罚卖家：只要卖家账上有钱就被扣保证金。\n', '            var pf = sellerGuaranteeEther;\n', '            if (pf > userEtherOf[_seller]){\n', '                pf = userEtherOf[_seller];\n', '            }\n', '            if(pf > 0){\n', '                userEtherOf[owner] +=  pf / 2;           \n', '                userEtherOf[msg.sender] +=   pf - pf / 2;\n', '                userEtherOf[_seller] -= pf;\n', '            }\n', '        }\n', '        \n', '        unLock();\n', '        return;\n', '    }\n', '\n', '    function () public payable {\n', '        if(msg.value > 0){          //来者不拒，比抛出异常或许更合适。\n', '            userEtherOf[msg.sender] += msg.value;\n', '        }\n', '    }\n', '\n', '    function disToken(address _token) public {          //处理捡到的各种Token，也就是别人误操作，直接给 this 发送了 token 。由调用者和Owner平分。因为这种误操作导致的丢失过去一年的损失达到几十万美元。\n', '        lock();\n', '\n', '        Erc20Token token = Erc20Token(_token);  //目前只处理 ERC20 Token，那些非标准Token就会永久丢失！\n', '        var amount = token.balanceOf(this);     //有一定风险，2017-09-27\n', '        if (amount > 0){\n', '            var a1 = amount / 2;\n', '            if (a1 > 0){\n', '                token.transfer(msg.sender, a1); //有一定风险，2017-09-27\n', '            }\n', '            var a2 = amount - a1;\n', '            if (a2 > 0){\n', '                token.transfer(owner, a2);      //有一定风险，2017-09-27\n', '            }\n', '        }\n', '\n', '        unLock();\n', '    }\n', '}']