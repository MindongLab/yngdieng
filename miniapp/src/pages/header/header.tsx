import React, {useState} from 'react';
import Taro, {useRouter} from '@tarojs/taro';
import clsx from 'clsx';
import {View, Block, Image, Text} from '@tarojs/components';
import {AtIcon, AtDrawer} from 'taro-ui';
import routes from '@/routes';
import logoURL from '@/assets/logo-header.png';
import styles from './header.module.scss';

interface MenuItem {
  title: string;
  iconType: string;
  navigateToRoute?: string;
  navigateToMiniApp?: any;
}

const menuItems: Array<MenuItem> = [
  {
    title: '首页',
    iconType: 'home',
    navigateToRoute: routes.INDEX,
  },
  {
    title: '搜索',
    iconType: 'search',
    navigateToRoute: routes.SEARCH,
  },
  {
    title: '关于',
    iconType: 'alert-circle',
    navigateToRoute: routes.ABOUT,
  },
  {
    title: '意见反馈',
    iconType: 'message',
    navigateToMiniApp: {
      // 兔小巢
      appId: 'wx8abaf00ee8c3202e',
      extraData: {
        id: '172407',
      },
    },
  },
];

const Header = ({injectedComponents = <Block />}) => {
  const router = useRouter();
  const routePath = router.path || '';
  const [showSidebar, toggleSidebar] = useState(false);

  const navigateTo = routePath => {
    Taro.redirectTo({
      url: routePath,
    });
  };
  const menuItemClicked = (menuItem: MenuItem) => {
    if (menuItem.navigateToRoute) {
      navigateTo(menuItem.navigateToRoute);
    } else if (menuItem.navigateToMiniApp) {
      Taro.navigateToMiniProgram(menuItem.navigateToMiniApp);
    }
  };

  return (
    <Block>
      <View className={styles.headerPlaceholder} />
      <View
        id="header"
        className={clsx(
          styles.header,
          routePath === routes.INDEX && styles.index
        )}
      >
        {[routes.INDEX].includes(routePath) && (
          <View>
            <AtIcon
              value="menu"
              color="#664445"
              onClick={() => toggleSidebar(true)}
            ></AtIcon>
          </View>
        )}
        {[routes.SEARCH, routes.WORD_DETAIL, routes.COLLECTION_DETAIL].includes(
          routePath
        ) && (
          <View>
            <AtIcon value="menu" onClick={() => toggleSidebar(true)}></AtIcon>
          </View>
        )}
        {[routes.WORD_DETAIL, routes.COLLECTION_DETAIL].includes(routePath) && (
          <View>
            <Image className={styles.logo} mode="heightFix" src={logoURL} />
          </View>
        )}
        {[routes.WORD_DETAIL, routes.COLLECTION_DETAIL].includes(routePath) && (
          <View onClick={() => navigateTo(routes.SEARCH)}>
            <AtIcon value="search"></AtIcon>
          </View>
        )}
        {injectedComponents}
      </View>
      <AtDrawer show={showSidebar} onClose={() => toggleSidebar(false)} mask>
        <View id="sidebar_container" className={styles.sidebarContainer}>
          <View className={styles.header}>
            <AtIcon value="close" onClick={() => toggleSidebar(false)}></AtIcon>
          </View>
          <View className={styles.content}>
            <View className={styles.title}>榕典</View>
            <View>
              {menuItems.map(menuItem => (
                <View
                  className={styles.menuItem}
                  key={menuItem.title}
                  onClick={() => menuItemClicked(menuItem)}
                >
                  <AtIcon value={menuItem.iconType}></AtIcon>
                  <Text className={styles.text}>{menuItem.title}</Text>
                </View>
              ))}
            </View>
          </View>
        </View>
      </AtDrawer>
    </Block>
  );
};

export default Header;
