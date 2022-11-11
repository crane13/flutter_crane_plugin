package cn.crane.crane_plugin_example

import cn.crane.crane_plugin.CraneApp

class App : CraneApp() {

    override fun onCreate() {
        super.onCreate()
        initConfig()
    }


    private fun initConfig() {
//        Const.ADMOB_ID = ""

//        RewardManager.list.add(RewardUtils_admob)
    }
}