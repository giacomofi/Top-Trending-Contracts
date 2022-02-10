['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-15\n', '*/\n', '\n', 'pragma solidity >=0.5.0 <0.7.0;\n', '\n', 'contract mortgage {\n', '      modifier onlyOwner{\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    // USDValue = 1000,\n', '    // security = 300,\n', '    // securityAmount = 0.246,\n', '    // securityCurrency = ETH,\n', '    // scurityRate = 0.00082\n', '    // lended = 700,\n', '    // lendedCurrency = AGCoin,\n', '    // lendedRate = 1,\n', '   \n', '    // event newrate(uint rate);\n', '    \n', '    event deployed(address owner , uint id);\n', '    \n', '    event userDetails1 (address user_address,\n', '        uint id,\n', '        uint asset_value_USD,\n', '        AsssetType deposited_asset,\n', '        AsssetType lend_asset,\n', '        mortgage_state m_state,\n', '        uint lended_value,\n', '        uint time,\n', '        uint rate,\n', '        uint interestrate,\n', '        uint max_mortgage);\n', '        // uint security_value);\n', '        \n', '    event userDetails2(uint absolute_mortgage,\n', '        uint security_rate,\n', '        uint lended_Rate,\n', '        // uint absolute_mortgage,\n', '        uint mortgage_amount,\n', '        uint deposited_value,  //initial deposited value\n', '        AsssetType withdrawl,\n', '        uint withdrawState,\n', '        uint deposited_asset_rate,\n', '        uint lended_asset_rate,\n', '        uint interest);\n', '        \n', '    event userDetails3(AsssetType extra_asset,\n', '        uint extraamount);\n', '    \n', '    address public owner;\n', '    uint public id ;\n', '    uint public rate;\n', '    uint public interestrate;\n', '    \n', '    enum AsssetType{\n', '        AGCoin, ETH, BTC, LTC, USDT\n', '    }\n', '\n', '    enum mortgage_state {\n', '        none, asked, provided\n', '    } \n', '    \n', '    struct Mortgage1 { \n', '        address  user;\n', '        uint id ;\n', '        uint asset_value_USD;\n', '        AsssetType deposited_asset;\n', '        AsssetType lend_asset;\n', '        mortgage_state m_state;\n', '        uint lended_value;\n', '        uint time;\n', '        uint rate;\n', '        uint interestrate;\n', '        uint max_mortgage;\n', '        \n', '    }\n', '    mapping(uint  => uint) ratess;\n', '        \n', '    struct Mortgage2 {\n', '        uint absolute_mortgage;\n', '        uint security_rate;\n', '        uint lended_Rate;\n', '        uint mortgage_amount;\n', '        uint deposited_value;\n', '        AsssetType withdrawl;\n', '        uint withdrawState;\n', '        uint deposited_asset_rate;\n', '        uint lended_asset_rate;\n', '        uint interest;\n', '    }\n', '    \n', '    struct Mortgage3 {\n', '        AsssetType extra_asset;\n', '        uint extraamount;\n', '    }\n', '    \n', '    \n', '     event rates (uint rate_AGCoin,\n', '        uint rate_ETH,\n', '        uint rate_BTC,\n', '        uint rate_LTC,\n', '        uint rate_XRP,\n', '        uint rate_USD);\n', '        \n', '     mapping(uint=>Mortgage1) public user_details1;\n', '     mapping(uint=>Mortgage2) public user_details2;\n', '     mapping(uint=>Mortgage3) public user_details3;\n', '\n', '     constructor() public {\n', '        owner = msg.sender;\n', '        id=1;\n', '        emit deployed(owner, id);\n', '    }\n', '    \n', '    \n', '    function setrate(uint _rate) onlyOwner public {\n', '        rate = _rate;\n', '        // emit newrate(rate);\n', '    }\n', '    \n', '     function setinterestrate(uint _interestrate) onlyOwner public {\n', '        interestrate = _interestrate;\n', '        // emit newrate(rate);\n', '    }\n', '   \n', '    \n', '    function settingUser(uint asset_value_USD, AsssetType _deposited_asset, AsssetType _lend_asset, uint _time, uint _deposited_value,uint _deposited_asset_rate, uint _lended_asset_rate,uint _lended_value) public {\n', '        require(_time>= 3 , "Mortgage should be for atleast 3 months");\n', '        require(_deposited_value >=500, "security should be greater than 500 USD");\n', '        uint _rate = rate;\n', '        uint _interestrate = interestrate;\n', '        uint calculateInterest = (asset_value_USD * _interestrate * _time)/(100 * 12);\n', '        \n', '        user_details1[id].user = msg.sender;\n', '        user_details1[id].id = id;\n', '        user_details2[id].deposited_value = _deposited_value;\n', '        user_details1[id].lended_value = _lended_value;\n', '        user_details1[id].asset_value_USD = asset_value_USD;\n', '        user_details2[id].lended_asset_rate = _lended_asset_rate;\n', '        user_details2[id].deposited_asset_rate = _deposited_asset_rate;\n', '        user_details2[id].absolute_mortgage = _deposited_value;\n', '        user_details1[id].lend_asset = _lend_asset;\n', '        user_details1[id].deposited_asset = _deposited_asset;\n', '        user_details2[id].withdrawl=AsssetType.AGCoin;\n', '        user_details3[id].extra_asset = _deposited_asset;\n', '        // user_details2[msg.sender][id].extraamount = extraamount;\n', '        user_details1[id].m_state = mortgage_state.provided;\n', '        user_details1[id].time =_time;\n', '        user_details1[id].rate= _rate;\n', '        user_details1[id].interestrate= _interestrate;\n', '        user_details2[id].interest= calculateInterest;\n', '        \n', '        emit userDetails1(user_details1[id].user,\n', '        user_details1[id].id,\n', '        user_details1[id].asset_value_USD,\n', '        user_details1[id].deposited_asset,\n', '        user_details1[id].lend_asset,\n', '        user_details1[id].m_state,\n', '        user_details1[id].lended_value,\n', '        user_details1[id].time,\n', '        user_details1[id].rate,\n', '        user_details1[id].interestrate,\n', '        user_details1[id].max_mortgage);\n', '        \n', '        emit userDetails2(user_details2[id].absolute_mortgage,\n', '        user_details2[id].security_rate,\n', '        user_details2[id].lended_Rate,\n', '        user_details2[id].mortgage_amount,\n', '        user_details2[id].deposited_value,\n', '        user_details2[id].withdrawl,\n', '        user_details2[id].withdrawState,\n', '        user_details2[id].deposited_asset_rate,\n', '        user_details2[id].lended_asset_rate,\n', '        user_details2[id].interest);\n', '        \n', '        emit userDetails3(user_details3[id].extra_asset,\n', '        user_details3[id].extraamount);\n', '        \n', '        id=id+1;\n', '    }\n', '    \n', '    \n', '    function addExtra (uint _id, uint extraAmount )  public {\n', '        // uint oldExtra = user_details2[_id].extraamount;\n', '        uint newExtra = user_details3[_id].extraamount + extraAmount;\n', '        user_details3[_id].extraamount = newExtra;\n', '        \n', '        emit userDetails1(user_details1[_id].user,\n', '        user_details1[_id].id,\n', '        user_details1[_id].asset_value_USD,\n', '        user_details1[_id].deposited_asset,\n', '        user_details1[_id].lend_asset,\n', '        user_details1[_id].m_state,\n', '        user_details1[_id].lended_value,\n', '        user_details1[_id].time,\n', '        user_details1[_id].rate,\n', '        user_details1[_id].interestrate,\n', '        user_details1[_id].max_mortgage);\n', '        \n', '        emit userDetails2(user_details2[_id].absolute_mortgage,\n', '        user_details2[_id].security_rate,\n', '        user_details2[_id].lended_Rate,\n', '        user_details2[_id].mortgage_amount,\n', '        user_details2[_id].deposited_value,\n', '        user_details2[_id].withdrawl,\n', '        user_details2[_id].withdrawState,\n', '        user_details2[_id].deposited_asset_rate,\n', '        user_details2[_id].lended_asset_rate,\n', '        user_details2[_id].interest);\n', '        \n', '        emit userDetails3(user_details3[_id].extra_asset,\n', '        user_details3[_id].extraamount);\n', '        \n', '    } \n', '    \n', '    \n', '    function cal_mortgage (uint _id )  public {\n', '        if (user_details1[_id].deposited_asset == AsssetType.AGCoin ) {\n', '            user_details1[_id].max_mortgage =  user_details2[_id].deposited_value*80/100;\n', '        }\n', '        else {\n', '            user_details1[_id].max_mortgage =  (user_details2[_id].deposited_value*rate)/100;\n', '        }\n', '        require(user_details2[_id].mortgage_amount >= user_details1[_id].max_mortgage, "");\n', '        \n', '        emit userDetails1(user_details1[_id].user,\n', '        user_details1[_id].id,\n', '        user_details1[_id].asset_value_USD,\n', '        user_details1[_id].deposited_asset,\n', '        user_details1[_id].lend_asset,\n', '        user_details1[_id].m_state,\n', '        user_details1[_id].lended_value,\n', '        user_details1[_id].time,\n', '        user_details1[_id].rate,\n', '        user_details1[_id].interestrate,\n', '        user_details1[_id].max_mortgage);\n', '        \n', '        emit userDetails2(user_details2[_id].absolute_mortgage,\n', '        user_details2[_id].security_rate,\n', '        user_details2[_id].lended_Rate,\n', '        user_details2[_id].mortgage_amount,\n', '        user_details2[_id].deposited_value,\n', '        user_details2[_id].withdrawl,\n', '        user_details2[_id].withdrawState,\n', '        user_details2[_id].deposited_asset_rate,\n', '        user_details2[_id].lended_asset_rate,\n', '        user_details2[_id].interest);\n', '        \n', '        emit userDetails3(user_details3[_id].extra_asset,\n', '        user_details3[_id].extraamount);\n', '        \n', '    } \n', '    \n', '    function withdraw(uint _id) onlyOwner public{\n', '        user_details1[_id].m_state = mortgage_state.provided;\n', '        user_details2[_id].withdrawState = 1;\n', '        \n', '        emit userDetails1(user_details1[_id].user,\n', '        user_details1[_id].id,\n', '        user_details1[_id].asset_value_USD,\n', '        user_details1[_id].deposited_asset,\n', '        user_details1[_id].lend_asset,\n', '        user_details1[_id].m_state,\n', '        user_details1[_id].lended_value,\n', '        user_details1[_id].time,\n', '        user_details1[_id].rate,\n', '        user_details1[_id].interestrate,\n', '        user_details1[_id].max_mortgage);\n', '        \n', '        emit userDetails2(user_details2[_id].absolute_mortgage,\n', '        user_details2[_id].security_rate,\n', '        user_details2[_id].lended_Rate,\n', '        user_details2[_id].mortgage_amount,\n', '        user_details2[_id].deposited_value,\n', '        user_details2[_id].withdrawl,\n', '        user_details2[_id].withdrawState,\n', '        user_details2[_id].deposited_asset_rate,\n', '        user_details2[_id].lended_asset_rate,\n', '        user_details2[_id].interest);\n', '        \n', '        emit userDetails3(user_details3[_id].extra_asset,\n', '        user_details3[_id].extraamount);\n', '    }\n', '}']