package cn.crane.crane_plugin.privacy;


import android.content.Context;
import android.text.Html;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.Spanned;
import android.text.TextPaint;
import android.text.TextUtils;
import android.text.method.DigitsKeyListener;
import android.text.method.LinkMovementMethod;
import android.text.style.ClickableSpan;
import android.text.style.URLSpan;
import android.view.View;
import android.widget.TextView;


import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


/**
 * Created by ruifengyu on 17/5/16.
 */

public class TextViewUtils {

    // TextView 链接去掉下划线
    public static void stripUnderlines(TextView textView) {
        stripUnderlines(textView, false);
    }
    public static void stripUnderlines(TextView textView, boolean showUnderLine) {
        try {
            if (null != textView && textView.getText() instanceof Spannable) {
                Spannable s = (Spannable) textView.getText();
                URLSpan[] spans = s.getSpans(0, s.length(), URLSpan.class);
                Spannable sp = (Spannable)textView.getText();

                SpannableStringBuilder style=new SpannableStringBuilder(textView.getText());
                style.clearSpans();
                for(URLSpan url : spans){
                    MyURLSpan myURLSpan = new MyURLSpan(url.getURL(), showUnderLine);
                    style.setSpan(myURLSpan,sp.getSpanStart(url),sp.getSpanEnd(url),Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
                }
                textView.setText(style);
            }

        }catch (Exception e)
        {
            e.printStackTrace();
        }

    }

    public static void stripUnderlinesClickable(TextView tv) {
        try {
            CharSequence charSequence = tv.getText();
            SpannableStringBuilder builder = new SpannableStringBuilder(
                    charSequence);
            URLSpan[] urlSpans = builder.getSpans(0, charSequence.length(),
                    URLSpan.class);
            for (URLSpan span : urlSpans) {
                int start = builder.getSpanStart(span);
                int end = builder.getSpanEnd(span);
                int flag = builder.getSpanFlags(span);
                final String link = span.getURL();
                builder.setSpan(new MyURLSpan(link, false) {
                    @Override
                    public void onClick(View widget) {
                    }
                }, start, end, flag);
                builder.removeSpan(span);
            }

            tv.setLinksClickable(true);

            tv.setText(builder);

        }catch (Exception e)
        {
            e.printStackTrace();
        }

    }

    public static class MyURLSpan extends ClickableSpan {

        private String mUrl;
        private boolean showUnderLine;

        public MyURLSpan(String url, boolean showUnderLine) {
            mUrl = url;
            this.showUnderLine = showUnderLine;
        }

        @Override
        public void updateDrawState(TextPaint ds) {
            super.updateDrawState(ds);
            ds.setColor(ds.linkColor);
            ds.setUnderlineText(showUnderLine);
        }

        @Override
        public void onClick(View widget) {
//            BaseJumpUtils.jumpToWebviewBase(BaseApp.getContext(), mUrl, "");
        }
    }

    private static class TextUrlSpan extends URLSpan {

        private String text;

        public String getText() {
            return text;
        }

        public TextUrlSpan(String text, String url) {
            super(url);
            this.text = text;
        }
    }


    public static String textContainUrlToLink(String urlText) {

        if(TextUtils.isEmpty(urlText))
        {
            return "";
        }
        // 先拆分原字符串的超链接和文本
        Spanned spanned = Html.fromHtml(urlText);
        SpannableStringBuilder builder = new SpannableStringBuilder(spanned);
        URLSpan[] spans = builder.getSpans(0, builder.length(), URLSpan.class);
        String newUrlText = builder.toString();
        ArrayList<Object> list = new ArrayList<>();
        if (spans != null) {
            int index = 0;
            for (URLSpan urlSpan : spans) {
                int start = builder.getSpanStart(urlSpan);
                int end = builder.getSpanEnd(urlSpan);
                if (start >= 0 && end >= 0) {
                    if(start <= newUrlText.length()) {
                        list.add(newUrlText.substring(index, start));
                    }
                    if(end <= newUrlText.length()) {
                        list.add(new TextUrlSpan(newUrlText.substring(start, end), urlSpan.getURL()));
                    }
                    index = end;
                }
            }
            if(index >= 0) {
                list.add(newUrlText.substring(index, newUrlText.length()));
            }
        } else {
            list.add(newUrlText);
        }

        //再用正则表达式匹配文本中的链接，最后把超链接和匹配到的链接文本合并
        // url的正则表达式
        String regexp = "((http[s]{0,1})://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";                                     // 结束条件
        Pattern pattern = Pattern.compile(regexp, Pattern.CASE_INSENSITIVE);

        String newStr = "";

        for (int i = 0; i < list.size(); i++) {

            if (list.get(i) instanceof String) {
                String str = (String) list.get(i);
                Matcher matcher = pattern.matcher(str);

                String resultText = "";// （临时变量，保存转换后的文本）
                int lastEnd = 0;// 保存每个链接最后一会的下标

                while (matcher.find()) {
                    if (lastEnd >=0 && matcher.start() >=0 && matcher.start() <= str.length()) {
                        resultText += str.substring(lastEnd, matcher.start());
                    }
                    String url = matcher.group();
                    //匹配到没有协议的链接，默认使用http
                    if(!url.startsWith("http") && !url.startsWith("https")) {
                        url = "http://" + url;
                    }
                    resultText += "<a href=\"" + url+ "\">" + url + "</a>";
                    lastEnd = matcher.end();
                }

                if(lastEnd >= 0) {
                    resultText += str.substring(lastEnd);
                }

                newStr += resultText;
            } else if (list.get(i) instanceof TextUrlSpan) {
                TextUrlSpan urlSpan = (TextUrlSpan) list.get(i);
                String url = urlSpan.getURL();
                //匹配到没有协议的链接，默认使用http
                if(!url.startsWith("http") && !url.startsWith("https")) {
                    url = "http://" + url;
                }
                newStr += "<a href=\"" + url + "\">" + urlSpan.getText() + "</a>";
            }

        }
        return newStr;
    }

    public static void  dealwithLink(final TextView tv, final Callback callback)
    {
        if(tv != null)
        {
            CharSequence charSequence = tv.getText();
            SpannableStringBuilder builder = new SpannableStringBuilder(
                    charSequence);
            URLSpan[] urlSpans = builder.getSpans(0, charSequence.length(),
                    URLSpan.class);
            for (URLSpan span : urlSpans) {
                int start = builder.getSpanStart(span);
                int end = builder.getSpanEnd(span);
                int flag = builder.getSpanFlags(span);
                final String link = span.getURL();
                final String title = "";
                builder.setSpan(new MyURLSpan(link, false) {
                    @Override
                    public void onClick(View widget) {
                        if(callback != null)
                        {
                            callback.onUrlClicked(link, title);
                        }
                    }
                }, start, end, flag);
                builder.removeSpan(span);
            }

            tv.setLinksClickable(true);

            tv.setText(builder);

            tv.setMovementMethod(LinkMovementMethod.getInstance());


        }

    }

    public interface Callback{
        void onUrlClicked(String url, String title);
    }

    public static void setSciolCodeEdit(TextView tv) {
        if (tv != null) {
            tv.setKeyListener(DigitsKeyListener.getInstance("0123456789ABCDEFGHJKLMNPQRTUWXY"));
        }
    }


    /**
     * 摩点内链点击
     */
    public static class MyMDURLSpan extends ClickableSpan {

        private String mUrl;
        private int color;
        private Context context;

        public MyMDURLSpan(String url,int color,Context context) {
            mUrl = url;
            this.color = color;
            this.context = context;
        }

        @Override
        public void updateDrawState(TextPaint ds) {
            ds.setColor(context.getResources().getColor(color));
            ds.setUnderlineText(false);
        }

        @Override
        public void onClick(View widget) {
//            BaseJumpUtils.openBrowser(BaseApp.getContext(), mUrl);
        }
    }

    private static final String UrlEndAppendNextChars = "[$]";



    private static class LinkSpec {
        String url;
        int start;
        int end;
    }

    public static String getFormatNumToString(int num){

        if(num < 0)
            return "0";

        if(num < 10000){
            return String.valueOf(num);
        }else{

            float newNum =  (float) num/ (float) 10000;
            DecimalFormat df = new DecimalFormat("0.0");


            return df.format(newNum) + "万";
        }

    }

}
