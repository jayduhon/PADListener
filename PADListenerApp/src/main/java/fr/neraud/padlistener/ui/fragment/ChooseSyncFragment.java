package fr.neraud.padlistener.ui.fragment;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import fr.neraud.log.MyLog;
import fr.neraud.padlistener.model.ChooseSyncModel;
import fr.neraud.padlistener.ui.activity.ChooseSyncActivity;
import fr.neraud.padlistener.ui.helper.ChooseSyncDataPagerHelper;

/**
 * Main fragment for ChooseSync
 *
 * @author Neraud
 */
public class ChooseSyncFragment extends AbstractViewPagerFragment {

	private ChooseSyncDataPagerHelper mHelper;

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		MyLog.entry();

		final ChooseSyncModel chooseResult = ((ChooseSyncActivity) getActivity()).getChooseResult();
		mHelper = new ChooseSyncDataPagerHelper(getActivity(), chooseResult);

		final View view = super.onCreateView(inflater, container, savedInstanceState);
		MyLog.exit();
		return view;
	}

	@Override
	protected int getPageCount() {
		return mHelper.getCount();
	}

	@Override
	protected Fragment getPageFragment(int position) {
		return mHelper.createFragment(position);
	}

	@Override
	protected Integer getTabTitle(int position) {
		return mHelper.getTitle(position);
	}

	@Override
	protected void notifyFragmentSelected(int position) {
	}

}
